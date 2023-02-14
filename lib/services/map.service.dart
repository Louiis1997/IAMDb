import 'dart:convert';
import 'dart:math' show cos, sqrt, asin, max, min;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/maps/map-camera-position.dart';

class CustomPolylines {
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  CustomPolylines({
    required this.polylineCoordinates,
    required this.polylinePoints,
    required this.polylines,
  });
}

class MapService {
  static final MapService _instance = MapService._internal();

  // API KEY
  String? googleMapsApiKey;

  factory MapService() {
    var googleMapsApiKey = dotenv.get('GOOGLE_MAPS_API_KEY', fallback: null);
    if (googleMapsApiKey == null || googleMapsApiKey.isEmpty) {
      throw Exception('GOOGLE_MAPS_API_KEY not found');
    }
    _instance.googleMapsApiKey = googleMapsApiKey;
    return _instance;
  }

  MapService._internal();

  MapCameraPosition getCorrectZoomFromStartAndDestination({
    required double startLatitude,
    required double startLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) {
    // Calculating to check that the position relative to the frame, and pan & zoom the camera accordingly.
    // Zoom lower because there is text on top of the map.
    double northEastLatitude = max(startLatitude, destinationLatitude);
    double northEastLongitude = max(startLongitude, destinationLongitude);
    double southWestLatitude = min(startLatitude, destinationLatitude);
    double southWestLongitude = min(startLongitude, destinationLongitude);

    return MapCameraPosition(
      northEastLatitude: northEastLatitude + 0.0009,
      northEastLongitude: northEastLongitude + 0.0009,
      southWestLatitude: southWestLatitude - 0.0009,
      southWestLongitude: southWestLongitude - 0.0009,
    );
  }

  void applyCameraReajustmentWithStartAndDestination(
    GoogleMapController mapController,
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) {
    if (destinationLatitude == 0.0 && destinationLongitude == 0.0) {
      MapService().moveCameraTo(
        mapController,
        startLatitude,
        startLongitude,
      );
      return;
    }
    MapCameraPosition cameraCorrection = getCorrectZoomFromStartAndDestination(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      destinationLatitude: destinationLatitude,
      destinationLongitude: destinationLongitude,
    );
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(cameraCorrection.northEastLatitude,
                cameraCorrection.northEastLongitude),
            southwest: LatLng(cameraCorrection.southWestLatitude,
                cameraCorrection.southWestLongitude),
          ),
          100),
    );
  }

  void zoomIn(GoogleMapController mapController) {
    mapController.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  void zoomOut(GoogleMapController mapController) {
    mapController.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void moveCameraTo(
      GoogleMapController mapController, double latitude, double longitude) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            latitude,
            longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  // Create the polylines for showing the route between two places
  Future<CustomPolylines> createPolylines(
    double startLatitude,
    double startLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
    TravelMode travelMode,
  ) async {
    if (destinationLatitude == null || destinationLongitude == null) {
      return CustomPolylines(
        polylineCoordinates: [],
        polylinePoints: PolylinePoints(),
        polylines: {},
      );
    }

    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];

    var polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey!,
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: travelMode,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    Map<PolylineId, Polyline> polylines = {};
    polylines[id] = polyline;

    return CustomPolylines(
      polylineCoordinates: polylineCoordinates,
      polylinePoints: polylinePoints,
      polylines: polylines,
    );
  }

  /**
   * Calculated with this formula: https://www.movable-type.co.uk/scripts/latlong.html
   *
      double _coordinateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
      }
   */
  Future<double> getDistanceBetweenTwoPoints(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Calculating the distance between the start and end positions with a straight path, without considering any route
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      destinationLatitude,
      destinationLongitude,
    );
  }

  /**
   * Formula for calculating distance between two coordinates
   * https://stackoverflow.com/a/54138876/11910277
   */
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> getPreciseDistanceBetweenTwoPoints(
      List<LatLng> polylineCoordinates) async {
    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += await _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    return totalDistance;
  }

  /**
   * Calculate time to travel between two points
   *
   * TODO - Not working for now
   */
  Future<String?> getTimeToTravelBetweenTwoPoints(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
    String mode,
  ) async {
    try {
      const mapsDistanceTimeUrl =
          "https://maps.googleapis.com/maps/api/distancematrix/json";
      var response = await http.get(Uri.parse(
          "$mapsDistanceTimeUrl?units=imperial&origins=$startLongitude,$startLatitude&destinations=$destinationLongitude,$destinationLatitude&key=$googleMapsApiKey!&mode=$mode"));
      if (response.statusCode != 200) {
        // log("Error getting time to travel: ${response.body} - ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
      return json.decode(response.body)["rows"][0]["elements"][0]["duration"]
          ["text"];
    } catch (e) {
      // log("Error getting time to travel: $e");
      return null;
    }
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iamdb/common/utils.dart';
import 'package:iamdb/models/maps/map-arguments.dart';
import 'package:iamdb/services/locator.service.dart';
import 'package:iamdb/services/map.service.dart';

// Tutorial : https://blog.codemagic.io/creating-a-route-calculator-using-google-maps/
class MapView extends StatefulWidget {
  final MapArguments mapArguments;

  const MapView({
    Key? key,
    required this.mapArguments,
  }) : super(key: key);

  static const String routeName = '/map-view';

  static void navigateTo(BuildContext context, MapArguments mapArguments) {
    Navigator.of(context).pushNamed(routeName, arguments: mapArguments);
  }

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  Set<Marker> markers = {};
  CameraPosition initialLocation = CameraPosition(target: LatLng(0, 0));

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  String? distanceInMetersFromStartToDestination;

  TravelMode travelMode = TravelMode.driving;
  bool isLoading = false;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();

  String startFullAddress = '';
  double startLatitude = 0;
  double startLongitude = 0;
  String destinationFullAddress = '';
  double destinationLatitude = 0;
  double destinationLongitude = 0;

  @override
  void initState() {
    super.initState();
    // Initial location of the Map view
    initialLocation = CameraPosition(
        target: LatLng(widget.mapArguments.userLatitude,
            widget.mapArguments.userLongitude));

    if (startAddressController.text == '') {
      startFullAddress = widget.mapArguments.userFullAddress;
      startLatitude = widget.mapArguments.userLatitude;
      startLongitude = widget.mapArguments.userLongitude;
    }
    if (destinationAddressController.text == '') {
      destinationFullAddress = widget.mapArguments.destinationFullAddress ?? '';
      destinationLatitude = widget.mapArguments.destinationLatitude ?? 0;
      destinationLongitude = widget.mapArguments.destinationLongitude ?? 0;
    }

    if (markers.isEmpty) {
      startAddressController.text = startFullAddress;
      destinationAddressController.text = destinationFullAddress;
      refreshMapWithNewStartAndDestination(fromInitialisation: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determining the screen width & height to available space
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return buildMapView(
      height,
      width,
      initialLocation,
    );
  }

  Future<void> refreshMapWithNewStartAndDestination({
    bool fromInitialisation = false,
  }) async {
    if (startFullAddress == '' || destinationFullAddress == '') {
      return;
    }

    if (!fromInitialisation) {
      distanceInMetersFromStartToDestination = "Computing...";
      isLoading = true;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
    }

    // Determine latitude & longitude of the start & destination addresses
    try {
      var startLocation =
          (await LocatorService().getLocationsFromAddress(startFullAddress))
              .first;
      startLatitude = startLocation.latitude;
      startLongitude = startLocation.longitude;
    } catch (e) {
      isLoading = false;
      Navigator.of(context).pop();
      setState(() {
        distanceInMetersFromStartToDestination = "impossible";
      });
      Utils.displayAlertDialog(
        context,
        'Start address validity',
        'Could not find start address on the map',
      );
      return;
    }

    try {
      var destinationLocation = (await LocatorService()
              .getLocationsFromAddress(destinationFullAddress))
          .first;
      destinationLatitude = destinationLocation.latitude;
      destinationLongitude = destinationLocation.longitude;
    } catch (e) {
      isLoading = false;
      Navigator.of(context).pop();
      setState(() {
        distanceInMetersFromStartToDestination = "impossible";
      });
      Utils.displayAlertDialog(
        context,
        'Destination address validity',
        'Could not find destination address on the map',
      );
      return;
    }

    // Start & Destination markers
    String startCoordinatesString = '(${startLatitude}, ${startLongitude})';
    String destinationCoordinatesString =
        destinationLatitude != 0 && destinationLongitude != 0
            ? '(${destinationLatitude}, ${destinationLongitude})'
            : '';

    // Start Marker
    try {
      Marker startMarker = LocatorService().getMarkerFromLocation(
        titlePrefix: 'Start',
        coordinatesString: startCoordinatesString,
        latitude: startLatitude,
        longitude: startLongitude,
        address: startFullAddress,
      );
      setState(() {
        markers.add(startMarker);
      });
    } catch (e) {
      isLoading = false;
      Navigator.of(context).pop();
      setState(() {
        distanceInMetersFromStartToDestination = "impossible";
      });
      Utils.displayAlertDialog(
        context,
        'Start address validity',
        'Could not find start address on the map',
      );
      return;
    }

    // Destination Marker
    if (destinationLatitude != 0 &&
        destinationLongitude != 0 &&
        destinationFullAddress != '') {
      try {
        Marker destinationMarker = LocatorService().getMarkerFromLocation(
          titlePrefix: 'Destination',
          coordinatesString: destinationCoordinatesString,
          latitude: destinationLatitude,
          longitude: destinationLongitude,
          address: destinationFullAddress,
        );
        setState(() {
          markers.add(destinationMarker);
        });
      } catch (e) {
        isLoading = false;
        Navigator.of(context).pop();
        setState(() {
          distanceInMetersFromStartToDestination = "impossible";
        });
        Utils.displayAlertDialog(
          context,
          'Destination address validity',
          'Could not find destination address on the map',
        );
        return;
      }


      if (polylines.isEmpty) {
        CustomPolylines createdPolylines;
        try {
          createdPolylines = await MapService().createPolylines(
            startLatitude,
            startLongitude,
            destinationLatitude,
            destinationLongitude,
            travelMode,
          );
        } catch (e) {
          isLoading = false;
          Navigator.of(context).pop();
          setState(() {
            distanceInMetersFromStartToDestination = "impossible";
          });
          Utils.displayAlertDialog(
            context,
            'Route validity',
            'Could not find a route between the two addresses',
          );
          return;
        }

        MapService().applyCameraReajustmentWithUserAndDestination(
          mapController,
          startLatitude,
          startLongitude,
          destinationLatitude,
          destinationLongitude,
        );

        double preciseDistance = 0;
        if (createdPolylines.polylineCoordinates.isEmpty) {
          isLoading = false;
          Navigator.of(context).pop();
          Utils.displayAlertDialog(
            context,
            'Routing',
            'Could not find a route between the two addresses',
          );
        }
        else {
          preciseDistance =
          await MapService().getPreciseDistanceBetweenTwoPoints(
            createdPolylines.polylineCoordinates,
          );

          // TODO Not working yet
          // var timeToTravel = await MapService().getTimeToTravelBetweenTwoPoints(
          //   startLatitude,
          //   startLongitude,
          //   destinationLatitude,
          //   destinationLongitude,
          //   travelMode.toString(),
          // );
        }

        setState(() {
          polylines = createdPolylines.polylines;
          polylineCoordinates = createdPolylines.polylineCoordinates;
          polylinePoints = createdPolylines.polylinePoints;

          // Storing the calculated total distance of the route
          distanceInMetersFromStartToDestination =
              preciseDistance == 0 ? "impossible" : preciseDistance.toStringAsFixed(2) + " km";

          if (isLoading) {
            Navigator.of(context).pop();
            isLoading = false;
          }
        });
      }
    }
  }

  Widget buildMapView(height, width, initialLocation) {
    // For controlling the view of the Map
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;

                if (destinationLatitude != 0 && destinationLongitude != 0) {
                  MapService().applyCameraReajustmentWithUserAndDestination(
                    mapController,
                    startLatitude,
                    startLongitude,
                    destinationLatitude,
                    destinationLongitude,
                  );
                }
              },
            ),
            // Show the place input fields & button for showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          createTextField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              prefixIcon: Icon(Icons.looks_one),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () async {
                                  // Get user location
                                  var newLocation =
                                      await LocatorService().localizeMe();
                                  var newStartFullAddress =
                                      await LocatorService()
                                          .getAddressFromCoordinates(
                                    newLocation.latitude,
                                    newLocation.longitude,
                                  );
                                  setState(() {
                                    startLatitude = newLocation.latitude;
                                    startLongitude = newLocation.longitude;
                                    startFullAddress = newStartFullAddress;
                                    startAddressController.text =
                                        startFullAddress;
                                    startFullAddress = startFullAddress;
                                  });
                                },
                              ),
                              controller: startAddressController,
                              focusNode: startAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                startFullAddress = value;
                              }),
                          SizedBox(height: 10),
                          createTextField(
                              label: 'Destination',
                              hint: 'Event location',
                              isModifiable: false,
                              prefixIcon: Icon(Icons.looks_two),
                              controller: destinationAddressController,
                              focusNode: destinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                // destinationFullAddress = value;
                              }),
                          SizedBox(height: 10),
                          Visibility(
                            visible:
                                distanceInMetersFromStartToDestination == null
                                    ? false
                                    : true,
                            child: Text(
                              'Distance: $distanceInMetersFromStartToDestination',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: () async {
                              if (startFullAddress.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Enter start address'),
                                  ),
                                );
                                return;
                              }
                              if (destinationFullAddress.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Enter destination address'),
                                  ),
                                );
                                return;
                              }

                              startAddressFocusNode.unfocus();
                              destinationAddressFocusNode.unfocus();

                              setState(() {
                                if (markers.isNotEmpty) markers.clear();
                                if (polylines.isNotEmpty) polylines.clear();
                              });

                              refreshMapWithNewStartAndDestination();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show route',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Button to move camera to the event location
            destinationLatitude != 0 && destinationLongitude != 0
                ? Positioned(
                    // bottom right
                    bottom: 298,
                    right: 20,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColorLight,
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.location_pin, color: Colors.red),
                          ),
                          onTap: () {
                            // Move camera to the specified latitude & longitude
                            if (mapController == null) {
                              log('MapController is null');
                              return;
                            }
                            MapService().moveCameraTo(
                              mapController,
                              destinationLatitude,
                              destinationLongitude,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            // Button to move camera to the user location
            Positioned(
              // bottom right
              bottom: 232,
              right: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColor,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.person_outline, color: Colors.black87),
                    ),
                    onTap: () {
                      // Move camera to the specified latitude & longitude
                      MapService().moveCameraTo(
                        mapController,
                        startLatitude,
                        startLongitude,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Button to move camera to see both user & event location
            destinationLatitude != 0 && destinationLongitude != 0
                ? Positioned(
                    // bottom right
                    bottom: 166,
                    right: 20,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColor,
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.zoom_out_map_sharp,
                                color: Colors.black87),
                          ),
                          onTap: () {
                            MapService()
                                .applyCameraReajustmentWithUserAndDestination(
                              mapController,
                              startLatitude,
                              startLongitude,
                              destinationLatitude,
                              destinationLongitude,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Container(),
            // Button to zoom in
            Positioned(
              // bottom right
              bottom: 100,
              right: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.add, color: Colors.black87),
                    ),
                    onTap: () {
                      MapService().zoomIn(mapController);
                    },
                  ),
                ),
              ),
            ),
            // Button to zoom out
            Positioned(
              // bottom right
              bottom: 34,
              right: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.remove, color: Colors.black87),
                    ),
                    onTap: () {
                      MapService().zoomOut(mapController);
                    },
                  ),
                ),
              ),
            ),
            // User can change his way of transportation
            Positioned(
              // bottom right
              bottom: 166,
              left: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: travelMode == TravelMode.walking
                      ? Theme.of(context).primaryColorLight
                      : Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.directions_walk, color: Colors.black87),
                    ),
                    onTap: () {
                      if (travelMode == TravelMode.walking) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (markers.isNotEmpty) markers.clear();
                        if (polylines.isNotEmpty) polylines.clear();
                        travelMode = TravelMode.walking;
                        refreshMapWithNewStartAndDestination();
                      });
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom right
              bottom: 100,
              left: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: travelMode == TravelMode.bicycling
                      ? Theme.of(context).primaryColorLight
                      : Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.directions_bike_rounded,
                          color: Colors.black87),
                    ),
                    onTap: () {
                      if (travelMode == TravelMode.bicycling) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (markers.isNotEmpty) markers.clear();
                        if (polylines.isNotEmpty) polylines.clear();
                        travelMode = TravelMode.bicycling;
                        refreshMapWithNewStartAndDestination();
                      });
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              // bottom right
              bottom: 34,
              left: 20,
              child: ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: travelMode == TravelMode.driving
                      ? Theme.of(context).primaryColorLight
                      : Color.fromRGBO(255, 255, 255, 0.9),
                  child: InkWell(
                    splashColor: Theme.of(context).primaryColorLight,
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.directions_car, color: Colors.black87),
                    ),
                    onTap: () {
                      if (travelMode == TravelMode.driving) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (markers.isNotEmpty) markers.clear();
                        if (polylines.isNotEmpty) polylines.clear();
                        travelMode = TravelMode.driving;
                        refreshMapWithNewStartAndDestination();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? suffixIcon,
    required Function(String) locationCallback,
    bool isModifiable = true,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          enabled: isModifiable,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }
}

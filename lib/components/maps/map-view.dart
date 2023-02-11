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
  late GoogleMapController _mapController;

  Set<Marker> _markers = {};
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0, 0));

  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> _polylines = {};
  late PolylinePoints _polylinePoints;
  List<LatLng> _polylineCoordinates = [];
  String? _distanceInMetersFromStartToDestination;

  TravelMode _travelMode = TravelMode.driving;
  bool _isLoading = false;

  final _startAddressController = TextEditingController();
  final _destinationAddressController = TextEditingController();

  final _startAddressFocusNode = FocusNode();
  final _destinationAddressFocusNode = FocusNode();

  String _startFullAddress = '';
  double _startLatitude = 0;
  double _startLongitude = 0;
  String _destinationFullAddress = '';
  double _destinationLatitude = 0;
  double _destinationLongitude = 0;

  @override
  void initState() {
    super.initState();
    // Initial location of the Map view
    _initialLocation = CameraPosition(
        target: LatLng(widget.mapArguments.startLatitude,
            widget.mapArguments.startLongitude));

    if (_startAddressController.text == '') {
      _startFullAddress = widget.mapArguments.startFullAddress;
      _startLatitude = widget.mapArguments.startLatitude;
      _startLongitude = widget.mapArguments.startLongitude;
    }
    if (_destinationAddressController.text == '') {
      _destinationFullAddress = widget.mapArguments.destinationFullAddress ?? '';
      _destinationLatitude = widget.mapArguments.destinationLatitude ?? 0;
      _destinationLongitude = widget.mapArguments.destinationLongitude ?? 0;
    }

    if (_markers.isEmpty) {
      _startAddressController.text = _startFullAddress;
      _destinationAddressController.text = _destinationFullAddress;
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
      _initialLocation,
    );
  }

  Future<void> refreshMapWithNewStartAndDestination({
    bool fromInitialisation = false,
  }) async {
    if ((_startFullAddress == '' || _destinationFullAddress == '') &&
        widget.mapArguments.withRouting == true) {
      return;
    }

    if (!fromInitialisation) {
      _distanceInMetersFromStartToDestination = "Computing...";
      _isLoading = true;
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
          (await LocatorService().getLocationsFromAddress(_startFullAddress))
              .first;
      _startLatitude = startLocation.latitude;
      _startLongitude = startLocation.longitude;
    } catch (e) {
      _isLoading = false;
      Navigator.of(context).pop();
      setState(() {
        _distanceInMetersFromStartToDestination = "impossible";
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
              .getLocationsFromAddress(_destinationFullAddress))
          .first;
      _destinationLatitude = destinationLocation.latitude;
      _destinationLongitude = destinationLocation.longitude;
    } catch (e) {
      if (widget.mapArguments.withRouting == true) {
        _isLoading = false;
        Navigator.of(context).pop();
        setState(() {
          _distanceInMetersFromStartToDestination = "impossible";
        });
        Utils.displayAlertDialog(
          context,
          'Destination address validity',
          'Could not find destination address on the map',
        );
        return;
      }
    }

    // Start & Destination markers
    String startCoordinatesString = '(${_startLatitude}, ${_startLongitude})';
    String destinationCoordinatesString =
        _destinationLatitude != 0 && _destinationLongitude != 0
            ? '(${_destinationLatitude}, ${_destinationLongitude})'
            : '';

    // Start Marker
    try {
      Marker startMarker = LocatorService().getMarkerFromLocation(
        titlePrefix: 'Start',
        coordinatesString: startCoordinatesString,
        latitude: _startLatitude,
        longitude: _startLongitude,
        address: _startFullAddress,
      );
      setState(() {
        _markers.add(startMarker);
      });
    } catch (e) {
      if (widget.mapArguments.withRouting == true) {
        _isLoading = false;
        Navigator.of(context).pop();
        setState(() {
          _distanceInMetersFromStartToDestination = "impossible";
        });
        Utils.displayAlertDialog(
          context,
          'Start address validity',
          'Could not find start address on the map',
        );
        return;
      }
    }

    // Destination Marker
    if (_destinationLatitude != 0 &&
        _destinationLongitude != 0 &&
        _destinationFullAddress != '') {
      try {
        Marker destinationMarker = LocatorService().getMarkerFromLocation(
          titlePrefix: 'Destination',
          coordinatesString: destinationCoordinatesString,
          latitude: _destinationLatitude,
          longitude: _destinationLongitude,
          address: _destinationFullAddress,
        );
        setState(() {
          _markers.add(destinationMarker);
        });
      } catch (e) {
        if (widget.mapArguments.withRouting == true) {
          _isLoading = false;
          Navigator.of(context).pop();
          setState(() {
            _distanceInMetersFromStartToDestination = "impossible";
          });
          Utils.displayAlertDialog(
            context,
            'Destination address validity',
            'Could not find destination address on the map',
          );
          return;
        }
      }

      if (_polylines.isEmpty && widget.mapArguments.withRouting == true) {
        CustomPolylines createdPolylines = CustomPolylines(
          polylineCoordinates: [],
          polylines: {},
          polylinePoints: PolylinePoints(),
        );
        try {
          createdPolylines = await MapService().createPolylines(
            _startLatitude,
            _startLongitude,
            _destinationLatitude,
            _destinationLongitude,
            _travelMode,
          );
        } catch (e) {
          if (widget.mapArguments.withRouting == true) {
            _isLoading = false;
            Navigator.of(context).pop();
            setState(() {
              _distanceInMetersFromStartToDestination = "impossible";
            });
            Utils.displayAlertDialog(
              context,
              'Route validity',
              'Could not find a route between the two addresses',
            );
            return;
          }
        }

        MapService().applyCameraReajustmentWithStartAndDestination(
          _mapController,
          _startLatitude,
          _startLongitude,
          _destinationLatitude,
          _destinationLongitude,
        );

        double preciseDistance = 0;
        if (widget.mapArguments.withRouting == true) {
          if (createdPolylines.polylineCoordinates.isEmpty) {
            _isLoading = false;
            Navigator.of(context).pop();
            Utils.displayAlertDialog(
              context,
              'Routing',
              'Could not find a route between the two addresses',
            );
          } else {
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
        }

        setState(() {
          _polylines = createdPolylines.polylines;
          _polylineCoordinates = createdPolylines.polylineCoordinates;
          _polylinePoints = createdPolylines.polylinePoints;

          // Storing the calculated total distance of the route
          _distanceInMetersFromStartToDestination = preciseDistance == 0
              ? "impossible"
              : preciseDistance.toStringAsFixed(2) + " km";
        });
      }
    }
    setState(() {
      MapService().applyCameraReajustmentWithStartAndDestination(
        _mapController,
        _startLatitude,
        _startLongitude,
        _destinationLatitude,
        _destinationLongitude,
      );
      if (_isLoading) {
        Navigator.of(context).pop();
        _isLoading = false;
      }
    });
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
              markers: Set<Marker>.from(_markers),
              initialCameraPosition: initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(_polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;

                if (_destinationLatitude != 0 && _destinationLongitude != 0) {
                  MapService().applyCameraReajustmentWithStartAndDestination(
                    _mapController,
                    _startLatitude,
                    _startLongitude,
                    _destinationLatitude,
                    _destinationLongitude,
                  );
                }
              },
            ),
            // Show the place input fields & button for showing the route
            widget.mapArguments.withRouting == false
                ? Positioned(
                    top: 100,
                    left: 20,
                    child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        child: InkWell(
                          splashColor: Theme.of(context).primaryColorLight,
                          child: SizedBox(
                            width: 46,
                            height: 46,
                            child:
                                Icon(Icons.arrow_back, color: Colors.black87),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ))
                : Container(),
            widget.mapArguments.withRouting == false
                ? Container()
                : SafeArea(
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
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
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
                                          _startLatitude = newLocation.latitude;
                                          _startLongitude =
                                              newLocation.longitude;
                                          _startFullAddress =
                                              newStartFullAddress;
                                          _startAddressController.text =
                                              _startFullAddress;
                                          _startFullAddress = _startFullAddress;
                                        });
                                      },
                                    ),
                                    controller: _startAddressController,
                                    focusNode: _startAddressFocusNode,
                                    width: width,
                                    locationCallback: (String value) {
                                      _startFullAddress = value;
                                    }),
                                SizedBox(height: 10),
                                createTextField(
                                    label: 'Destination',
                                    hint: 'Event location',
                                    isModifiable: false,
                                    prefixIcon: Icon(Icons.looks_two),
                                    controller: _destinationAddressController,
                                    focusNode: _destinationAddressFocusNode,
                                    width: width,
                                    locationCallback: (String value) {
                                      // destinationFullAddress = value;
                                    }),
                                SizedBox(height: 10),
                                Visibility(
                                  visible:
                                      _distanceInMetersFromStartToDestination ==
                                              null
                                          ? false
                                          : true,
                                  child: Text(
                                    'Distance: $_distanceInMetersFromStartToDestination',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipOval(
                                        clipBehavior: Clip.antiAlias,
                                        child: Material(
                                          color: Color.fromRGBO(
                                              230, 230, 230, 0.9),
                                          child: InkWell(
                                            splashColor: Theme.of(context)
                                                .primaryColorLight,
                                            child: SizedBox(
                                              width: 46,
                                              height: 46,
                                              child: Icon(Icons.arrow_back,
                                                  color: Colors.black87),
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (_startFullAddress.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Enter start address'),
                                              ),
                                            );
                                            return;
                                          }
                                          if (_destinationFullAddress.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Enter destination address'),
                                              ),
                                            );
                                            return;
                                          }

                                          _startAddressFocusNode.unfocus();
                                          _destinationAddressFocusNode.unfocus();

                                          setState(() {
                                            if (_markers.isNotEmpty)
                                              _markers.clear();
                                            if (_polylines.isNotEmpty)
                                              _polylines.clear();
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
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipOval(
                                        clipBehavior: Clip.antiAlias,
                                        child: Material(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 0),
                                          child: InkWell(
                                            splashColor: Theme.of(context)
                                                .primaryColorLight,
                                            child: SizedBox(
                                              width: 46,
                                              height: 46,
                                              // no icon
                                              child: Icon(Icons.arrow_back,
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            // Button to move camera to the event location
            _destinationLatitude != 0 && _destinationLongitude != 0
                ? Positioned(
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
                            if (_mapController == null) {
                              log('MapController is null');
                              return;
                            }
                            MapService().moveCameraTo(
                              _mapController,
                              _destinationLatitude,
                              _destinationLongitude,
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
              bottom: 232 - (widget.mapArguments.withRouting == true ? 0 : 66),
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
                      child: Icon(
                        widget.mapArguments.withRouting == true
                            ? Icons.person_outline
                            : Icons.location_pin,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      // Move camera to the specified latitude & longitude
                      MapService().moveCameraTo(
                        _mapController,
                        _startLatitude,
                        _startLongitude,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Button to move camera to see both user start & event location
            _destinationLatitude != 0 && _destinationLongitude != 0
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
                                .applyCameraReajustmentWithStartAndDestination(
                              _mapController,
                              _startLatitude,
                              _startLongitude,
                              _destinationLatitude,
                              _destinationLongitude,
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
                      MapService().zoomIn(_mapController);
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
                      MapService().zoomOut(_mapController);
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
                  color: _travelMode == TravelMode.walking
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
                      if (_travelMode == TravelMode.walking) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (_markers.isNotEmpty) _markers.clear();
                        if (_polylines.isNotEmpty) _polylines.clear();
                        _travelMode = TravelMode.walking;
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
                  color: _travelMode == TravelMode.bicycling
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
                      if (_travelMode == TravelMode.bicycling) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (_markers.isNotEmpty) _markers.clear();
                        if (_polylines.isNotEmpty) _polylines.clear();
                        _travelMode = TravelMode.bicycling;
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
                  color: _travelMode == TravelMode.driving
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
                      if (_travelMode == TravelMode.driving) return;
                      // Reload the map with the new transportation mode
                      setState(() {
                        if (_markers.isNotEmpty) _markers.clear();
                        if (_polylines.isNotEmpty) _polylines.clear();
                        _travelMode = TravelMode.driving;
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

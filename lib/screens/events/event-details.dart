import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iamdb/common/date_helpers.dart';
import 'package:iamdb/components/maps/map-view.dart';
import 'package:iamdb/models/event.dart';
import 'package:iamdb/models/maps/map-arguments.dart';
import 'package:iamdb/services/locator.service.dart';

class EventDetails extends StatefulWidget {
  final Event event;

  const EventDetails({
    Key? key,
    required this.event,
  }) : super(key: key);

  static const String routeName = '/event-details';

  static void navigateTo(BuildContext context, Event event) {
    Navigator.of(context).pushNamed(routeName, arguments: event);
  }

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  double _userLatitude = 0;
  double _userLongitude = 0;
  String _userFullAddress = '';
  double? _eventLatitude;
  double? _eventLongitude;

  @override
  void initState() {
    super.initState();
    LocatorService().localizeMe().then((position) => {
          setState(() {
            _userLatitude = position.latitude;
            _userLongitude = position.longitude;
          })
        });
  }

  // This page is the event details page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/iamdb-logo.png',
          fit: BoxFit.contain,
          height: 64,
        ),
        // on touch show full name bc it can be long
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.event.name,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.event.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      'by ${widget.event.organizer}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      DateHelpers.formatEventDates(
                          startDate: widget.event.startDate,
                          endDate: widget.event.endDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Flexible(
                          child: Text(
                            '📍 ${widget.event.address}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          flex: 0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Flexible(
                          child: Text(
                            '${widget.event.city} ${widget.event.zipCode}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          flex: 0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Flexible(
                          child: Text(
                            widget.event.country,
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          flex: 0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color.fromRGBO(
                                      240, 240, 240, 1.0),
                                  child: IconButton(
                                    iconSize: 40,
                                    icon: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                    ),
                                    color: Colors.black87,
                                    onPressed: () async {
                                      if (_userLatitude == null ||
                                          _userLongitude == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please wait while we get your location'),
                                          ),
                                        );
                                        return;
                                      }
                                      String eventFullAddress =
                                          '${widget.event.address}, ${widget.event.city}, ${widget.event.zipCode}, ${widget.event.country}';
                                      List<Location> eventLocations =
                                          await LocatorService()
                                              .getLocationsFromAddress(
                                        eventFullAddress,
                                      );
                                      if (eventLocations.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'We could not find the location of this event',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      _eventLatitude = eventLocations.first.latitude;
                                      _eventLongitude = eventLocations.first.longitude;

                                      _userFullAddress = await LocatorService()
                                          .getAddressFromCoordinates(
                                        _userLatitude,
                                        _userLongitude,
                                      );

                                      MapView.navigateTo(
                                        context,
                                        MapArguments(
                                          userLatitude: _userLatitude,
                                          userLongitude: _userLongitude,
                                          userFullAddress: _userFullAddress,
                                          destinationLatitude: _eventLatitude,
                                          destinationLongitude: _eventLongitude,
                                          destinationFullAddress: eventFullAddress,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Text(
                                  'Localize & Navigate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

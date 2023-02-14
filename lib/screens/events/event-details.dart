import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iamdb/common/date.utils.dart';
import 'package:iamdb/screens/events/events.dart';
import 'package:iamdb/services/event.dart';

import '../../common/user-interface-dialog.utils.dart';
import '../../components/maps/map-view.dart';
import '../../models/event.dart';
import '../../models/maps/map-arguments.dart';
import '../../services/locator.service.dart';

class EventDetails extends ConsumerStatefulWidget {
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
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends ConsumerState<EventDetails> {
  double _userLatitude = 0;
  double _userLongitude = 0;
  String _userFullAddress = '';
  double? _eventLatitude;
  double? _eventLongitude;

  @override
  void initState() {
    super.initState();
    LocatorService()
        .localizeMe()
        .then(
          (position) => {
            setState(() {
              _userLatitude = position.latitude;
              _userLongitude = position.longitude;
            })
          },
        )
        .catchError(
          (error) => {
            log('Failed to get user location : $error'),
            UserInterfaceDialog.displaySnackBar(
              context: context,
              message: 'Failed to get your location :(',
              messageType: MessageType.error,
            ),
          },
        );
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
        centerTitle: true,
        actions: [
          Row(
            children: [
              _shouldBeAbleToCancelEvent(widget.event)
                  ? IconButton(
                      icon: const Icon(Icons.free_cancellation_sharp),
                      color: Colors.grey,
                      iconSize: 30,
                      onPressed: () => _onClickCancelEvent(),
                    )
                  : Container(),
              // Delete button
              widget.event.isCreator
                  ? IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: Colors.deepOrange,
                      iconSize: 30,
                      onPressed: () => _onClickDeleteEvent(),
                    )
                  : Container(),
            ],
          ),
        ],
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
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      DateHelpers.formatCompleteEventDates(
                          startDate: widget.event.startDate,
                          endDate: widget.event.endDate),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
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
                                  backgroundColor:
                                      Color.fromRGBO(240, 240, 240, 1.0),
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
                                        UserInterfaceDialog.displaySnackBar(
                                          context: context,
                                          message:
                                              'Please wait while we get your location :D',
                                          messageType: MessageType.info,
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
                                        UserInterfaceDialog.displaySnackBar(
                                          context: context,
                                          message:
                                              'We could not find the location of this event',
                                          messageType: MessageType.error,
                                        );
                                        return;
                                      }

                                      _eventLatitude =
                                          eventLocations.first.latitude;
                                      _eventLongitude =
                                          eventLocations.first.longitude;

                                      _userFullAddress = await LocatorService()
                                          .getAddressFromCoordinates(
                                        _userLatitude,
                                        _userLongitude,
                                      );

                                      MapView.navigateTo(
                                        context,
                                        MapArguments(
                                          startLatitude: _userLatitude,
                                          startLongitude: _userLongitude,
                                          startFullAddress: _userFullAddress,
                                          destinationLatitude: _eventLatitude,
                                          destinationLongitude: _eventLongitude,
                                          destinationFullAddress:
                                              eventFullAddress,
                                          withRouting: true,
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

  Future<void> _onClickCancelEvent() async {
    var reallyWantsToCancel =
        await UserInterfaceDialog.displayAlertDialogChoices(
      context: context,
      title: 'Cancel my event',
      question:
          'Are you sure you want to cancel this event? This action cannot be undone.',
      messageType: MessageType.warning,
      confirmBtn: TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Yes', style: TextStyle(color: Colors.red)),
      ),
      cancelBtn: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('No'),
      ),
    );
    if (reallyWantsToCancel) {
      await EventService.cancelEvent(widget.event.id);
      Navigator.of(context).pop(true);
      ref.read(eventChangedProvider.notifier).state =
          !ref.watch(eventChangedProvider);
    }
  }

  Future<void> _onClickDeleteEvent() async {
    var reallyWantsToDelete =
        await UserInterfaceDialog.displayAlertDialogChoices(
      context: context,
      title: 'Delete my event',
      question:
          'Are you SURE you want to delete this event? This action cannot be undone!',
      messageType: MessageType.error,
      confirmBtn: TextButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: const Text('Yes', style: TextStyle(color: Colors.red)),
      ),
      cancelBtn: TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text('No'),
      ),
    );
    if (reallyWantsToDelete) {
      await EventService.deleteEvent(widget.event.id);
      Navigator.of(context).pop(true);
      ref.read(eventChangedProvider.notifier).state =
          !ref.watch(eventChangedProvider);
    }
  }

  bool _shouldBeAbleToCancelEvent(Event event) {
    return event.cancelledAt == null &&
        event.startDate.isAfter(DateTime.now()) &&
        event.isCreator;
  }
}

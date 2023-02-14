import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iamdb/screens/events/events.dart';

import '../../common/date.utils.dart';
import '../../common/user-interface-dialog.utils.dart';
import '../../common/validators.dart';
import '../../components/maps/map-view.dart';
import '../../components/event_end_date_picker.dart';
import '../../components/event_end_time_picker.dart';
import '../../components/event_start_date_picker.dart';
import '../../components/event_start_time_picker.dart';
import '../../exceptions/events/event-creation.exception.dart';
import '../../exceptions/events/event-duplicate.exception.dart';
import '../../exceptions/unauthorized.exception.dart';
import '../../models/maps/map-arguments.dart';
import '../../services/locator.service.dart';
import '../../services/event.dart';

class EventCreation extends ConsumerStatefulWidget {
  const EventCreation({Key? key}) : super(key: key);

  static const String routeName = '/create-event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  EventCreationState createState() => EventCreationState();
}

class EventCreationState extends ConsumerState<EventCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _eventCategoryController =
      TextEditingController();
  final TextEditingController _eventOrganizerController =
      TextEditingController();
  final TextEditingController _eventAddressController = TextEditingController();
  final TextEditingController _eventCityController = TextEditingController();
  final TextEditingController _eventZipCodeController = TextEditingController();
  final TextEditingController _eventCountryController = TextEditingController();

  double _eventLatitude = 0;
  double _eventLongitude = 0;
  String _eventFullAddress = '';

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  bool _withEndDate = true;

  bool _isLoading = false;

  resetLatitudeAndLongitudeToZero() {
    setState(() {
      _eventLatitude = 0;
      _eventLongitude = 0;
    });
  }

  // This page contains a form to create an event
  @override
  Widget build(BuildContext context) {
    // Add listener on address information to set _eventLatitude and _eventLongitude to 0 when change
    return Scaffold(
        appBar: AppBar(
          title: const Text('Creation'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Make your own event! 🎉',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              'Global information',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: _eventNameController,
                          validator: (value) =>
                              Validator.validateForm(value ?? ""),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                            hintText: 'Japan Expo',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: _eventDescriptionController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                            hintText:
                                'The biggest event in France about Nippon culture',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: _eventCategoryController,
                          validator: (value) =>
                              Validator.validateForm(value ?? ""),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category',
                            hintText:
                                'Anime, Manga, Cosplay, J-pop, J-rock, J-drama, J-food, J-fashion, J-geek, J-otaku, J-culture, J-entertainment, J-technology, J-education',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 5),
                        child: TextFormField(
                          controller: _eventOrganizerController,
                          validator: (value) =>
                              Validator.validateForm(value ?? ""),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Organizer',
                            hintText: 'Sefa Event',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              'Localisation',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: _eventAddressController,
                          onChanged: (value) =>
                              resetLatitudeAndLongitudeToZero(),
                          validator: (value) =>
                              Validator.validateForm(value ?? ""),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                            hintText: 'Paris Expo Porte de Versailles',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _eventCityController,
                                onChanged: (value) =>
                                    resetLatitudeAndLongitudeToZero(),
                                validator: (value) =>
                                    Validator.validateForm(value ?? ""),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'City',
                                  hintText: 'Paris',
                                  filled: false,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _eventZipCodeController,
                                onChanged: (value) =>
                                    resetLatitudeAndLongitudeToZero(),
                                validator: (value) =>
                                    Validator.validateForm(value ?? ""),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Zip code',
                                  hintText: '75015',
                                  filled: false,
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: _eventCountryController,
                          onChanged: (value) =>
                              resetLatitudeAndLongitudeToZero(),
                          validator: (value) =>
                              Validator.validateForm(value ?? ""),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Country',
                            hintText: 'France',
                            filled: false,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ButtonTheme(
                                minWidth: double.infinity,
                                child: ElevatedButton(
                                    onPressed: onClickCheckEventLocation,
                                    child: Text(_eventLatitude != 0 &&
                                            _eventLongitude != 0
                                        ? 'Correct location ✅'
                                        : 'Check location'),
                                    style: ElevatedButton.styleFrom(
                                      primary: _eventLatitude != 0 &&
                                              _eventLongitude != 0
                                          ? Colors.green
                                          : Colors.black87,
                                      onPrimary: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          // TODO : Add a location chooser to set the latitude and longitude
                          _eventLatitude != 0 && _eventLongitude != 0
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: ButtonTheme(
                                    minWidth: double.infinity,
                                    child: ClipOval(
                                      clipBehavior: Clip.antiAlias,
                                      child: Material(
                                        color:
                                            Color.fromRGBO(230, 230, 230, 0.9),
                                        child: InkWell(
                                          splashColor: Theme.of(context)
                                              .primaryColorLight,
                                          child: SizedBox(
                                            width: 46,
                                            height: 46,
                                            child: Icon(Icons.location_pin,
                                                color: Colors.black87),
                                          ),
                                          onTap: () {
                                            onClickDisplayEventLocation();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 15, bottom: 5),
                        child: Row(
                          children: [
                            Text(
                              'Calendar information',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: EventStartDatePicker(
                                eventStartDateController: _startDateController,
                                startDateOnChange: (value) {
                                  _startDateOnChanged();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: EventStartScrollTimePicker(
                                eventStartTimeController: _startTimeController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Visibility(
                          visible: _withEndDate,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: EventEndDatePicker(
                                      eventEndDateController:
                                          _endDateController,
                                      minDate: _startDateController.text != ''
                                          ? DateHelpers.parseDateTime(
                                              _startDateController.text,
                                              _startTimeController.text == ''
                                                  ? '00:00:00'
                                                  : _startTimeController.text,
                                            ).add(const Duration(minutes: 1))
                                          : DateTime.now(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: EventEndScrollTimePicker(
                                      eventEndTimeController:
                                          _endTimeController,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            Visibility(
                              visible: !_withEndDate,
                              child: Row(
                                // Text with : If end date is not set, the event will end at the end of the day
                                children: [
                                  Expanded(
                                    child: Text(
                                      'If end date is not set, the event will end at the end of the day',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _withEndDate = !_withEndDate;
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: _withEndDate
                                          ? Color.fromRGBO(200, 200, 200, 1)
                                          : Theme.of(context).primaryColor,
                                    ),
                                    child: Text(
                                      _withEndDate
                                          ? 'Remove end date'
                                          : 'Add end date',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          onPressed: onClickCreateEventButton,
                          child: const Text(
                            'Submit your event',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Visibility(
                    child: AlertDialog(
                      elevation: 500,
                      backgroundColor: Colors.transparent,
                      content: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    visible: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> onClickCheckEventLocation() async {
    if (_eventAddressController.text.trim() != '' ||
        _eventCityController.text.trim() != '' ||
        _eventZipCodeController.text.trim() != '' ||
        _eventCountryController.text.trim() != '') {
      try {
        String address = _eventAddressController.text.trim() +
            ', ' +
            _eventCityController.text.trim() +
            ', ' +
            _eventZipCodeController.text.trim() +
            ', ' +
            _eventCountryController.text.trim();
        var locations;
        try {
          locations = (await LocatorService().getLocationsFromAddress(address));
          if (locations.isEmpty) {
            UserInterfaceDialog.displaySnackBar(
              context: context,
              message:
                  'We could not find the location of your event. Please check the event address you entered.',
              messageType: MessageType.error,
            );
            return false;
          }
        } catch (e) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                'We could not find the location of your event. Please check the event address you entered.',
            messageType: MessageType.error,
          );
          return false;
        }

        final location = locations.first;
        setState(() {
          _eventLatitude = location.latitude;
          _eventLongitude = location.longitude;
        });
        var newLocationFromCoordinates = await LocatorService()
            .getAddressFromCoordinates(location.latitude, location.longitude);
        setState(() {
          if (newLocationFromCoordinates != address &&
              newLocationFromCoordinates.split(',').where((element) {
                return element.trim() != '';
              }).isNotEmpty) {
            _eventFullAddress = newLocationFromCoordinates;
            _eventAddressController.text =
                _eventFullAddress.split(',')[0].trim();
            _eventCityController.text =
                _eventFullAddress.split(',')[1].trim().split(' ')[0].trim();
            _eventZipCodeController.text =
                _eventFullAddress.split(',')[1].trim().split(' ')[1].trim();
            _eventCountryController.text =
                _eventFullAddress.split(',')[2].trim();
          }
        });
        return true;
      } catch (e) {
        print(e);
        setState(() {
          _eventLatitude = 0;
          _eventLongitude = 0;
          _eventFullAddress = '';
        });
        UserInterfaceDialog.displaySnackBar(
          context: context,
          message: 'Could not find location',
          messageType: MessageType.error,
        );
        return false;
      }
    } else {
      setState(() {
        _eventLatitude = 0;
        _eventLongitude = 0;
        _eventFullAddress = '';
      });
      UserInterfaceDialog.displaySnackBar(
        context: context,
        message:
            'Please fill at least one of the address fields (address, city, zip code, country)',
        messageType: MessageType.warning,
      );
      return false;
    }
  }

  Future<void> onClickDisplayEventLocation() async {
    _eventFullAddress = await LocatorService().getAddressFromCoordinates(
      _eventLatitude,
      _eventLongitude,
    );

    MapView.navigateTo(
      context,
      MapArguments(
        startLatitude: _eventLatitude,
        startLongitude: _eventLongitude,
        startFullAddress: _eventFullAddress,
        withRouting: false,
      ),
    );
  }

  void onClickCreateEventButton() async {
    if (onClickCheckEventLocation() == false) {
      print("Location not found");
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        DateTime parsedStartDatetime = DateHelpers.parseDateTime(
            _startDateController.text, _startTimeController.text);
        DateTime parsedEndDatetime = DateHelpers.parseDateTime(
            _endDateController.text,
            _endTimeController.text == ''
                ? _startTimeController.text
                : _endTimeController.text);

        if (_withEndDate && (parsedStartDatetime.isAfter(parsedEndDatetime) ||
            parsedStartDatetime.isAtSameMomentAs(parsedEndDatetime))) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                'The event start date and time must be before the end date and time (if you do not specify an end time, the end time will be the start of the day)',
            messageType: MessageType.warning,
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });

        await EventService.create(
          eventName: _eventNameController.text.trim(),
          eventDescription: _eventDescriptionController.text.trim(),
          eventCategory: _eventCategoryController.text.trim(),
          eventOrganizer: _eventOrganizerController.text.trim(),
          eventAddress: _eventAddressController.text.trim(),
          eventCity: _eventCityController.text.trim(),
          eventZipCode: _eventZipCodeController.text.trim(),
          eventCountry: _eventCountryController.text.trim(),
          eventStartDate: parsedStartDatetime,
          eventEndDate: _withEndDate ? parsedEndDatetime : null,
          eventLongitude: _eventLongitude,
          eventLatitude: _eventLatitude,
        );
        Navigator.of(context).pop(true);
        ref.read(eventCreatedProvider.notifier).state =
            !ref.watch(eventCreatedProvider);
      } catch (err) {
        log("Error: $err");
        if (err is EventDuplicateException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "An event with this name already exists",
            messageType: MessageType.error,
          );
        } else if (err is EventCreationException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "Please check your inputs and try again",
            messageType: MessageType.error,
          );
        } else if (err is UnauthorizedException) {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message: "You are not authorized to create an event",
            messageType: MessageType.error,
          );
        } else {
          UserInterfaceDialog.displaySnackBar(
            context: context,
            message:
                "Couldn't create event. Please try again later or contact us if the problem persists.",
            messageType: MessageType.error,
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startDateOnChanged() {
    setState(() {
      _startDateController.text = _startDateController.text;
      if (_startDateController.text.isEmpty) {
        _endDateController.text = _startDateController.text;
      } else if (_endDateController.text.isEmpty) {
        _endDateController.text = _startDateController.text;
      } else if (DateTime.parse(_endDateController.text)
          .isBefore(DateTime.parse(_startDateController.text))) {
        _endDateController.text = _startDateController.text;
      }
    });
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:iamdb/common/utils.dart';
import 'package:iamdb/common/validator.dart';
import 'package:iamdb/components/event_end_date_picker.dart';
import 'package:iamdb/components/event_end_time_picker.dart';
import 'package:iamdb/components/event_start_date_picker.dart';
import 'package:iamdb/components/event_start_time_picker.dart';
import 'package:iamdb/exceptions/events/event-creation.exception.dart';
import 'package:iamdb/exceptions/events/event-duplicate.exception.dart';
import 'package:iamdb/exceptions/unauthorized.exception.dart';
import 'package:iamdb/main.dart';
import 'package:iamdb/services/event.service.dart';

class EventCreation extends StatefulWidget {
  const EventCreation({Key? key}) : super(key: key);

  static const String routeName = '/create-event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
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

  // TODO Map controller
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  bool _withEndDate = true;

  // This page contains a form to create an event
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Creation'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: _eventNameController,
                      validator: (value) => Validator.validateForm(value ?? ""),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: _eventCategoryController,
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
                      validator: (value) => Validator.validateForm(value ?? ""),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: _eventAddressController,
                      validator: (value) => Validator.validateForm(value ?? ""),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _eventCityController,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: _eventCountryController,
                      validator: (value) => Validator.validateForm(value ?? ""),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Country',
                        hintText: 'France',
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
                          'Calendar information',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: EventStartScrollDatePicker(
                            eventStartDateController: _startDateController,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Visibility(
                      visible: _withEndDate,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: EventEndScrollDatePicker(
                                  eventEndDateController: _endDateController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: EventEndScrollTimePicker(
                                  eventEndTimeController: _endTimeController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          ),
        ));
  }

  void onClickCreateEventButton() async {
    Navigator.pop(context);
    if (_formKey.currentState!.validate()) {
      try {
        String startDateTime = _startDateController.text.trim() +
            'T' +
            _startTimeController.text.trim() +
            'Z';
        DateTime parsedStartDatetime = DateTime.parse(startDateTime);
        String endDateTime = _endDateController.text.trim() +
            'T' +
            _endTimeController.text.trim() +
            'Z';
        DateTime parsedEndDatetime = DateTime.parse(endDateTime);

        final token = await storage.read(key: "token");
        if (token == null) {
          throw Exception('No JWT token found');
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

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
          eventEndDate: parsedEndDatetime,
          eventLongitude: 0.0,
          eventLatitude: 0.0,
          token: token,
        );
        Navigator.pop(context);
      } catch (err) {
        log("Error: $err");
        if (err is EventDuplicateException) {
          return Utils.displayAlertDialog(
            context,
            "Duplicate",
            "An event with this name already exists",
          );
        }
        if (err is EventCreationException) {
          return Utils.displayAlertDialog(
            context,
            "Invalid",
            "Please check your inputs and try again",
          );
        }
        if (err is UnauthorizedException) {
          return Utils.displayAlertDialog(
            context,
            "Unauthorized",
            "Please login again",
          );
        }
        return Utils.displayAlertDialog(
          context,
          "Couldn't create event",
          "Please try again later or contact us if the problem persists.",
        );
      }
    }
  }
}

// flutter: London Anime & Gaming Con 2023
// flutter: Animeleague exists to bring anime fans, gaming fans, cosplayers and general geeks together. We do this through online forums, social media, real-life meetups and conventions to help build one big family and community of friends together. We run over fifty events a year ranging from small free community meetups to free minicons to full-scale conventions.
//
// Our extremely active and friendly forums and community meetups which take place across every major city in the UK are free to join and come along to. Whether it's anime, gaming, cosplay, or just general chat and discussion about life in general, AL has something for everyone and all are invited. Make sure to be a part of one of the top anime communities in the world and join us today!.
// flutter: Anime and Games
// flutter: Animeleague
// flutter: Novotel London West
// flutter: London
// flutter: W6 8DR
// flutter: UK
// flutter: 2023-08-12
// flutter: 10:00:00
// flutter: 2023-08-13
// flutter: 21:00:00
// flutter: true

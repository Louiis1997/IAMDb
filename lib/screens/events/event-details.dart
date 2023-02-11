import 'package:flutter/material.dart';

import '../../common/date_helpers.dart';
import '../../models/event.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  const EventDetails({
    Key? key,
    required this.event,
  }) : super(key: key);

  static const String routeName = '/event-details';

  static void navigateTo(BuildContext context, Event event) {
    Navigator.of(context).pushNamed(routeName, arguments: event);
  }

  // This page is the event details page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: Image.asset(
            'assets/iamdb-logo.png',
            fit: BoxFit.contain,
            height: 64,
          ),
        ),
        // on touch show full name bc it can be long
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    event.name,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              event.description,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Container()),
                Text(
                  'by ${event.organizer}',
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
                Expanded(child: Container()),
                Text(
                  DateHelpers.formatEventDates(
                      startDate: event.startDate, endDate: event.endDate),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
              ],
            ),
          ),

          // TODO Add a map here to do location & directions using google maps
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
                        '📍 ${event.address}',
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
                        '${event.city} ${event.zipCode}',
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
                        event.country,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

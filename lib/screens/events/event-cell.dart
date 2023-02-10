import 'package:flutter/material.dart';
import 'package:iamdb/common/date.helpers.dart';
import 'package:iamdb/models/event.dart';
import 'package:iamdb/screens/events/event-details.dart';

class EventCell extends StatelessWidget {
  final Event event;

  const EventCell({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Color.fromRGBO(255, 255, 255, 0.8),
              child: InkWell(
                onTap: () {
                  EventDetails.navigateTo(context, event);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.name,
                                style: Theme.of(context).textTheme.headline2
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              '${event.city} - ${event.country}',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                event.description.length > 100
                                    ? '${event.description.substring(0, 100)}...'
                                    : event.description,
                              style: Theme.of(context).textTheme.bodyText2
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateHelpers.formatEventDates(startDate: event.startDate, endDate: event.endDate),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Empty container to align the text to the right
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

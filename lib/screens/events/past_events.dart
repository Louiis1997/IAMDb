import 'package:flutter/material.dart';
import 'package:iamdb/components/maps/error-message.dart';

import '../../models/event.dart';
import '../../screens/events/event-cell.dart';

class PastEvents extends StatelessWidget {
  final Future<List<dynamic>> future;

  const PastEvents({Key? key, required this.future}) : super(key: key);

  static const String routeName = '/past-event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No events have happened yet!'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // Cast to Event
                  final event = snapshot.data![index] as Event;
                  // Clickable cell
                  return EventCell(
                    event: event,
                  );
                },
              );
            } else {
              return const ErrorMessage(message: 'Failed to load past events 😞');
            }
          case ConnectionState.none:
            return const Center(child: Text('No connection'));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

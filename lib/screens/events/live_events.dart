import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../screens/events/event-cell.dart';

class LiveEvents extends StatelessWidget {
  final Future<List<dynamic>> future;

  const LiveEvents({Key? key, required this.future}) : super(key: key);

  static const String routeName = '/live-event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, snapshot) {
        // If no data show text
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No live events for now 🖖👇'));
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
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load past events'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
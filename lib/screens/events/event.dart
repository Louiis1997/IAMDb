import 'package:flutter/material.dart';

import '../../main.dart';
import '../../screens/events/live_events.dart';
import '../../screens/events/past_events.dart';
import '../../screens/events/upcoming_events.dart';
import '../../services/event.dart';

class Events extends StatelessWidget {
  const Events({Key? key}) : super(key: key);

  static const String routeName = '/event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  // This page has 3 tabs : Past events, Live events, Upcoming events
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Events'),
            bottom: const TabBar(
              tabs: [
                Tab(text: '👴🏻 Past 👵🏻'),
                Tab(text: 'Live 👇🏻'),
                Tab(text: 'Upcoming 🔮'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PastEvents(
                future: _getPastEvents(),
              ),
              LiveEvents(
                future: _getLiveEvents(),
              ),
              UpcomingEvents(
                future: _getUpcomingEvents(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _getPastEvents() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      throw Exception('No JWT token found');
    }
    return EventService.getPastEvents(token);
  }

  Future<List<dynamic>> _getLiveEvents() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      throw Exception('No JWT token found');
    }
    return EventService.getLiveEvents(token);
  }

  Future<List<dynamic>> _getUpcomingEvents() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      throw Exception('No JWT token found');
    }
    return EventService.getUpcomingEvents(token);
  }
}

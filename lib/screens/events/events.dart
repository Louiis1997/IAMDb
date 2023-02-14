import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/events/event-creation.dart';
import '../../screens/events/live_events.dart';
import '../../screens/events/past_events.dart';
import '../../screens/events/upcoming_events.dart';
import '../../services/event.dart';

final eventChangedProvider = StateProvider((ref) => false);
final eventCreatedProvider = StateProvider((ref) => false);

class Events extends ConsumerWidget {
  const Events({Key? key}) : super(key: key);

  static const String routeName = '/event';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  // This page has 3 tabs : Past events, Live events, Upcoming events
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _changed = ref.watch(eventChangedProvider);
    bool _created = ref.watch(eventCreatedProvider);

    TabBar _tabBar = TabBar(
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Theme.of(context).primaryColor,
      ),
      labelColor: Theme.of(context).primaryColor, // Selected text color
      unselectedLabelColor:
          Theme.of(context).textTheme.bodyText1!.color, // Unselected text color
      tabs: [
        Tab(text: 'Past 📜', icon: Icon(Icons.history)),
        Tab(text: 'Live 👇🏻', icon: Icon(Icons.live_tv)),
        Tab(text: 'Upcoming 🔮', icon: Icon(Icons.calendar_today)),
      ],
    );

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Events'),
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: Material(
                color: Colors.transparent,
                child: _tabBar,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: TabBarView(
            children: [
              PastEvents(
                future: (_changed == true || _created == true)
                    ? _getPastEvents()
                    : _getPastEvents(),
              ),
              LiveEvents(
                future: (_changed == true || _created == true)
                    ? _getLiveEvents()
                    : _getLiveEvents(),
              ),
              UpcomingEvents(
                future: (_changed == true || _created == true)
                    ? _getUpcomingEvents()
                    : _getUpcomingEvents(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              EventCreation.navigateTo(context);
            },
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Future<List<dynamic>> _getPastEvents() async {
    return EventService.getPastEvents();
  }

  Future<List<dynamic>> _getLiveEvents() async {
    return EventService.getLiveEvents();
  }

  Future<List<dynamic>> _getUpcomingEvents() async {
    return EventService.getUpcomingEvents();
  }

  newEventCreated() {
    // Reload page
  }
}

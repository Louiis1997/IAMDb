import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/agenda_list.dart';
import '../services/agenda.dart';

final boolProvider = StateProvider((ref) => false);

class Agenda extends ConsumerWidget {
  const Agenda({Key? key}) : super(key: key);

  static const String routeName = '/agenda';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static const List<Tab> agendaTabs = <Tab>[
    Tab(text: 'In progress', icon: Icon(Icons.play_arrow)),
    Tab(text: 'Paused', icon: Icon(Icons.pause)),
    Tab(text: 'Want to see', icon: Icon(Icons.favorite)),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _changed = ref.watch(boolProvider);

    TabBar _tabBar = TabBar(
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Theme.of(context).primaryColor,
      ),
      labelColor: Theme.of(context).primaryColor, // Selected text color
      unselectedLabelColor:
          Theme.of(context).textTheme.bodyText1!.color, // Unselected text color
      tabs: agendaTabs,
    );

    return Scaffold(
      body: DefaultTabController(
        length: agendaTabs.length,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Animes'),
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
              AgendaList(
                future: (_changed == true)
                    ? _getAgenda("En cours ⏳")
                    : _getAgenda("En cours ⏳"),
              ),
              AgendaList(
                future: (_changed == true)
                    ? _getAgenda("En pause 🤒")
                    : _getAgenda("En pause 🤒"),
              ),
              AgendaList(
                future: (_changed == true)
                    ? _getAgenda("Envie de voir 🤤")
                    : _getAgenda("Envie de voir 🤤"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _getAgenda(String status) async {
    return AgendaService.getAgendaByStatus(status);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/agenda_list.dart';
import '../main.dart';
import '../services/agenda.dart';

final boolProvider = StateProvider((ref) => false);

class Agenda extends ConsumerWidget {
  const Agenda({Key? key}) : super(key: key);

  static const String routeName = '/agenda';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static const List<Tab> agendaTabs = <Tab>[
    Tab(text: 'In progress'),
    Tab(text: 'Paused'),
    Tab(text: 'Want to see'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool _changed = ref.watch(boolProvider);
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  title: const Text('Animes'),
                  pinned: true,
                  bottom: TabBar(
                    labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                    unselectedLabelStyle:
                        Theme.of(context).tabBarTheme.unselectedLabelStyle,
                    indicatorColor: Colors.white,
                    tabs: agendaTabs,
                  ),
                  backgroundColor: Color.fromRGBO(255, 255, 255, 0.8),
                ),
              ];
            },
            body: TabBarView(
              children: [
                AgendaList(
                  future: (_changed == true) ? _getAgenda("En cours ⏳") : _getAgenda("En cours ⏳"),
                ),
                AgendaList(
                  future: (_changed == true) ? _getAgenda("En pause 🤒") : _getAgenda("En pause 🤒"),
                ),
                AgendaList(
                  future: (_changed == true) ? _getAgenda("Envie de voir 🤤") : _getAgenda("Envie de voir 🤤"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> _getAgenda(String status) async {
    final token = await storage.read(key: "token");
    return AgendaService.getAgendaByStatus(token!, status);
  }
}

import 'package:flutter/material.dart';

import '../components/agenda_list.dart';
import '../main.dart';
import '../services/agenda.dart';
import 'search.dart';

class Agenda extends StatelessWidget {
  const Agenda({Key? key}) : super(key: key);

  static const String routeName = '/agenda';

  static void navigateTo(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  static const List<Tab> agendaTabs = <Tab>[
    Tab(text: 'En cours'),
    Tab(text: 'En pause'),
    Tab(text: 'Envie de voir'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverAppBar(
                  title: const Text('Agenda'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Search.navigateTo(context);
                      },
                    ),
                  ],
                  pinned: true,
                  floating: true,
                  forceElevated: true,
                  bottom: TabBar(
                    labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                    unselectedLabelStyle:
                        Theme.of(context).tabBarTheme.unselectedLabelStyle,
                    indicatorColor: Colors.white,
                    tabs: agendaTabs,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                AgendaList(
                  future: _getAgenda("En cours ⏳"),
                ),
                AgendaList(
                  future: _getAgenda("En pause 🤒"),
                ),
                AgendaList(
                  future: _getAgenda("Envie de voir 🤤"),
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

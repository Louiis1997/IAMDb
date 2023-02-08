import 'package:flutter/material.dart';

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
                  pinned: true,
                  floating: true,
                  forceElevated: true,
                  bottom: TabBar(
                    labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                    unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle,
                    indicatorColor: Colors.white,
                    tabs: agendaTabs,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

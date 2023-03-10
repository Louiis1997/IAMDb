import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iamdb/components/image_grid.dart';

import '../services/agenda.dart';

class AnimeGrid extends StatelessWidget {
  final String status;

  const AnimeGrid({Key? key, required this.status}) : super(key: key);

  static const String routeName = '/anime_grid';

  static void navigateTo(BuildContext context, String status) {
    Navigator.of(context).pushNamed(routeName, arguments: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/iamdb-logo.png',
          fit: BoxFit.contain,
          height: 64,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'Anime - $status',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: buildFutureBuilderItem(),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder buildFutureBuilderItem() {
    return FutureBuilder(
      future: _getAgenda(status),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return Center(
                  child: Text(
                    'No anime added yet',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }
              return ImageGrid(
                snapshot: snapshot,
              );
            }
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Text('${snapshot.error}');
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<dynamic>> _getAgenda(String status) async {
    return AgendaService.getAgendaByStatus(status);
  }
}

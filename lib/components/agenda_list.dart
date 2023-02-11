import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/anime_detail.dart';
import '../services/anime.dart';
import 'anime_card.dart';

class AgendaList extends StatelessWidget {
  final Future<List<dynamic>> future;

  const AgendaList({Key? key, required this.future}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderItem();
  }

  FutureBuilder buildFutureBuilderItem() {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final data = snapshot.data;
              if (data == null || data.isEmpty) {
                return Center(
                  child: Text(
                    'No anime added yet',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              return buildAgendaListView(snapshot.data);
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

  SizedBox buildAgendaListView(data) {
    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return FutureBuilder(
            future: _getAnime(data[index].animeId, index),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final anime = snapshot.data;
                    if (anime == null) {
                      return Center(
                        child: Text(
                          'No anime found',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      );
                    }
                    return AnimeCard(
                      anime: anime,
                      onTap: () =>
                          {AnimeDetail.navigateTo(context, anime.malId)},
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
        },
      ),
    );
  }

  Future<dynamic> _getAnime(int id, int index) async {
    await Future.delayed(Duration(seconds: (index / 2).round()));
    final token = await storage.read(key: "token");
    return AnimeService.getAnimeById(token!, id);
  }
}

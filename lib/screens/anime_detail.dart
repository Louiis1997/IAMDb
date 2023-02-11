import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../main.dart';
import '../components/episodes_list.dart';
import '../components/anime_information.dart';
import '../models/anime.dart';
import '../models/episode.dart';
import '../services/anime.dart';

class AnimeDetail extends StatelessWidget {
  final int animeId;

  const AnimeDetail({Key? key, required this.animeId}) : super(key: key);

  static const String routeName = '/anime_detail';

  static void navigateTo(BuildContext context, int id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  static const List<Tab> animeDetailTabs = <Tab>[
    Tab(
      text: 'Information',
    ),
    Tab(text: 'Episodes'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Detail'),
      ),
      body: SlidingUpPanel(
        backdropEnabled: true,
        minHeight: 80,
        maxHeight: 300,
        panel: Text("This is the sliding Widget"),
        body: DefaultTabController(
          length: animeDetailTabs.length,
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints.expand(height: 50),
                child: Material(
                  color: Theme.of(context).colorScheme.background,
                  child: TabBar(
                    tabs: animeDetailTabs,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    AnimeInformation(future: _getAnime(animeId)),
                    EpisodeList(future: _getEpisodes(animeId))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Anime> _getAnime(int animeId) async {
    final token = await storage.read(key: "token");
    return AnimeService.getAnimeById(token!, animeId);
  }

  Future<List<Episode>> _getEpisodes(int animeId) async {
    final token = await storage.read(key: "token");
    return AnimeService.getAnimeEpisodes(token!, animeId);
  }
}

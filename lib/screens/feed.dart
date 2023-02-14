import 'package:flutter/material.dart';

import '../components/carousel_banner.dart';
import '../components/suggestion_list.dart';
import '../models/top_manga.dart';
import '../services/anime.dart';
import '../services/manga.dart';
import 'anime_detail.dart';
import 'manga_detail.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CarouselBanner(),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Text(
                "Anime this season",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SuggestionList(
              future: _getSeasonNow(),
              onTap: _onTapToAnime,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Text(
                "Most popular manga",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SuggestionList(
              future: _getTopManga(),
              onTap: _onTapToManga,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<dynamic>> _getTopManga() async {
    return MangaService.getTopManga();
  }

  Future<List<dynamic>> _getSeasonNow() async {
    return AnimeService.getSeasonNow();
  }

  void _onTapToAnime(BuildContext context, int id) {
    AnimeDetail.navigateTo(context, id);
  }

  void _onTapToManga(BuildContext context, TopManga manga) {
    MangaDetail.navigateTo(context, manga);
  }
}

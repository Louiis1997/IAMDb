import 'package:flutter/material.dart';
import 'package:iamdb/services/season.dart';

import '../components/carousel_banner.dart';
import '../components/suggestion_list.dart';
import '../services/top.dart';

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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Anime this season",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SuggestionList(future: SeasonService.getSeasonNow()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                "Most popular manga",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SuggestionList(future: TopService.getTopManga()),
          ],
        ),
      ),
    );
  }
}

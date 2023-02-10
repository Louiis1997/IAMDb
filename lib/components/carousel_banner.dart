import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../main.dart';
import '../screens/anime_detail.dart';
import '../screens/anime_trailer.dart';
import '../services/anime.dart';

class CarouselBanner extends StatelessWidget {
  const CarouselBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderTopAnime();
  }

  FutureBuilder buildFutureBuilderTopAnime() {
    return FutureBuilder(
      future: _getTopAnime(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              final animes = snapshot.data;
              if (animes == null || animes.isEmpty) {
                return Center(
                  child: Text(
                    'No anime found',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              return buildCarouselSliderTopAnime(snapshot.data);
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

  CarouselSlider buildCarouselSliderTopAnime(data) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 1,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return LayoutBuilder(
          builder: (BuildContext context, constraints) {
            final maxHeight = constraints.maxHeight;
            final maxWidth = constraints.maxWidth;
            return Stack(
              children: [
                GestureDetector(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: maxWidth,
                        child: Image.network(
                          data[index].trailerImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    AnimeTrailer.navigateTo(context, data[index].youtubeId);
                  },
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  top: maxHeight * .6,
                  start: maxWidth * .02,
                  child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: maxHeight * .4,
                          width: maxWidth * .2,
                          child: Image.network(
                            data[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: maxWidth * .7,
                          child: Text(
                            data[index].titleEnglish,
                            style: Theme.of(context).textTheme.subtitle2,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      AnimeDetail.navigateTo(context, data[index].malId);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _getTopAnime() async {
    final token = await storage.read(key: "token");
    return AnimeService.getTopAnime(token!);
  }
}

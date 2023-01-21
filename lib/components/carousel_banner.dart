import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../services/top.dart';
import '../screens/anime_detail.dart';
import '../screens/anime_trailer.dart';

class CarouselBanner extends StatelessWidget {
  const CarouselBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildFutureBuilderTopAnime();
  }

  FutureBuilder buildFutureBuilderTopAnime() {
    return FutureBuilder(
      future: TopService.getTopAnime(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return Text('${snapshot.error}');
            }
            return buildCarouselSliderTopAnime(snapshot.data);
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
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: data[index].youtubeId,
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                              hideControls: true,
                            ),
                          ),
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
                            style: Theme.of(context).textTheme.bodyText1,
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
}

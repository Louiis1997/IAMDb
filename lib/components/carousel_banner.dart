import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iamdb/models/top.dart';

import '../services/top.dart';

class CarouselBanner extends StatefulWidget {
  final Future<Top>? futureTop;

  const CarouselBanner({Key? key, this.futureTop}) : super(key: key);

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final TopService _topService = TopService();
  List<String> _images = [];
  List<String> _names = [];

  @override
  void initState() {
    _getTopAnimeInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.futureTop == null
        ? buildFutureBuilderTopAnime()
        : buildCarouselSliderTopAnime();
  }

  FutureBuilder<Top> buildFutureBuilderTopAnime() {
    return FutureBuilder<Top>(
      future: widget.futureTop,
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
            return buildCarouselSliderTopAnime();
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  CarouselSlider buildCarouselSliderTopAnime() {
    return CarouselSlider(
      options: CarouselOptions(
        initialPage: 0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 1,
        scrollDirection: Axis.horizontal,
      ),
      items: _images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .2,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  top: MediaQuery.of(context).size.height * .15,
                  start: MediaQuery.of(context).size.width * .02,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        width: MediaQuery.of(context).size.width * .2,
                        child: Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Text(
                          _names[_images.indexOf(image)],
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }

  _getTopAnimeInfo() async {
    Future<Top> top = _topService.getTopAnime();
    List<String> images = [];
    List<String> names = [];
    top.then((value) => value.anime.forEach((element) {
      images.add(element.imageUrl!);
      names.add(element.titleEnglish!);
      setState(() {
        _images = images;
        _names = names;
      });
    }));
  }
}

import 'package:flutter/material.dart';
import 'package:iamdb/components/carousel_banner.dart';

import '../models/top.dart';
import '../services/top.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final TopService _topService = TopService();
  Future<Top>? _futureTop;

  @override
  void initState() {
    _getTopAnime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselBanner(futureTop: _futureTop),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Anime Hiver 2023",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getTopAnime() async {
    Future<Top> top = _topService.getTopAnime();
    setState(() {
      _futureTop = top;
    });
  }
}

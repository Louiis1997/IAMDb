import 'package:flutter/material.dart';

import '../components/carousel_banner.dart';


class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CarouselBanner(),
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
}

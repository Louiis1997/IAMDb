import 'package:flutter/material.dart';

class AnimeDetail extends StatelessWidget {
  final int animeId;

  const AnimeDetail({Key? key, required this.animeId}) : super(key: key);

  static const String routeName = '/anime_detail';

  static void navigateTo(BuildContext context, int id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Detail'),
      ),
      body: Center(
        child: Text(
          'Anime Detail with id: $animeId',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

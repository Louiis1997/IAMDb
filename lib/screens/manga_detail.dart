import 'package:flutter/material.dart';

class MangaDetail extends StatelessWidget {
  final int mangaId;

  const MangaDetail({Key? key, required this.mangaId}) : super(key: key);

  static const String routeName = '/manga_detail';

  static void navigateTo(BuildContext context, int id) {
    Navigator.of(context).pushNamed(routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

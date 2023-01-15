import 'anime.dart';

class Top {
  List<Anime> anime;

  Top({required this.anime});

  factory Top.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Anime> animeList = list.map((i) => Anime.fromJson(i)).toList();
    return Top(anime: animeList);
  }

  @override
  toString() {
    return anime.toString();
  }

}
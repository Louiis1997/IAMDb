import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/anime.dart';

class TopService {
  final _baseUrl = "https://api.jikan.moe/v4/top";

  Future<List<Anime>> getTopAnime() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/anime"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request');
      }
    }
    final jsonBody = json.decode(response.body);
    final List<Anime> animes = [];
    for (final userJson in jsonBody['data']) {
      animes.add(Anime.fromJson(userJson));
    }
    return animes;
  }
}
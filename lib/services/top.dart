import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/top.dart';

class TopService {
  static const _baseUrl = "https://api.jikan.moe/v4/top";

  static Future<List<Top>> getTopAnime() async {
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
        case 404:
          throw Exception('Not Found');
        case 429:
          throw Exception('Too Many Request');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final jsonBody = json.decode(response.body);
    final List<Top> animes = [];
    for (final userJson in jsonBody['data']) {
      animes.add(Top.fromJson(userJson));
    }
    return animes;
  }
}
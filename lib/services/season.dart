import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/season.dart';

class SeasonService {
  static const _baseUrl = "https://api.jikan.moe/v4/seasons";

  static Future<List<Season>> getSeasonNow() async {
    final response = await http.get(
      Uri.parse("$_baseUrl/now"),
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
    final List<Season> animes = [];
    for (final animeJson in jsonBody['data']) {
      animes.add(Season.fromJson(animeJson));
    }
    return animes;
  }
}
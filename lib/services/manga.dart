import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/top_manga.dart';

class MangaService {
  static const _baseUrl = "http://localhost/mangas";

  static Future<List<TopManga>> getTopManga(String token) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(
      Uri.parse("$_baseUrl/top/manga"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $token'
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
    final List<TopManga> animes = [];
    for (final mangaJson in jsonBody['data']) {
      animes.add(TopManga.fromJson(mangaJson));
    }
    return animes;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/common/storage.utils.dart';

import '../models/top_manga.dart';

class MangaService {
  static const _baseUrl = "http://localhost/mangas";

  static Future<List<TopManga>> getTopManga() async {
    final token = await StorageUtils.getAuthToken();
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
          throw Exception('400: Bad request');
        case 401:
          throw Exception('401: Unauthorized');
        case 404:
          throw Exception('404: Not Found');
        case 429:
          throw Exception('429: Too Many Request');
        case 500:
          throw Exception('500: Internal Server Error');
        case 503:
          throw Exception('503: Service Unavailable');
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

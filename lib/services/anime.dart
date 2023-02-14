import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/common/storage.utils.dart';

import '../models/anime.dart';
import '../models/episode.dart';
import '../models/season.dart';
import '../models/top_anime.dart';

class AnimeService {
  static const _baseUrl = "http://localhost/animes";

  static Future<List<Anime>> search(
    String letter,
    String filter,
  ) async {
    final http.Response response;
    final token = await StorageUtils.getAuthToken();
    if (filter == "") {
      response = await http.get(
        Uri.parse("$_baseUrl/search?letter=$letter"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $token'
        },
      );
    } else {
      response = await http.get(
        Uri.parse("$_baseUrl/search?type=$filter&letter=$letter"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'bearer $token'
        },
      );
    }
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
    final List<Anime> animes = [];
    for (final animeJson in jsonBody['animes']) {
      animes.add(Anime.fromJson(animeJson));
    }
    return animes;
  }

  static Future<List<TopAnime>> getTopAnime() async {
    final token = await StorageUtils.getAuthToken();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(
      Uri.parse("$_baseUrl/top"),
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
    final List<TopAnime> animes = [];
    for (final animeJson in jsonBody['animes']) {
      animes.add(TopAnime.fromJson(animeJson));
    }
    return animes;
  }

  static Future<List<Season>> getSeasonNow() async {
    final token = await StorageUtils.getAuthToken();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(
      Uri.parse("$_baseUrl/seasons/now"),
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
    final List<Season> animes = [];
    for (final animeJson in jsonBody['animes']) {
      animes.add(Season.fromJson(animeJson));
    }
    return animes;
  }

  static Future<Anime> getAnimeById(int id, { int index = 1}) async {
    int retry = 0;
    while (retry < 20) {
      try {
        final token = await StorageUtils.getAuthToken();
        final response = await http.get(
          Uri.parse("$_baseUrl/$id"),
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
        final Anime anime = Anime.fromJson(jsonBody['anime']);
        return anime;
      } catch (e) {
        retry++;
        print('Échec de la requête. Nombre de tentatives restantes : $retry');
        if (retry == 20) {
          print('Nombre maximum de tentatives atteint');
          break;
        }
        await Future.delayed(Duration(seconds: index));
      }
    }
    return Future.error(Exception('500: Impossible de récupérer les données'));
  }

  static Future<List<Episode>> getAnimeEpisodes(int id) async {
    final token = await StorageUtils.getAuthToken();
    await Future.delayed(const Duration(seconds: 3));
    final response = await http.get(
      Uri.parse("$_baseUrl/$id/episodes"),
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
    final List<Episode> episodes = [];
    for (final episodeJson in jsonBody['data']) {
      episodes.add(Episode.fromJson(episodeJson));
    }
    return episodes;
  }
}

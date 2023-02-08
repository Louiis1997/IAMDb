import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/anime.dart';
import '../models/episode.dart';
import '../models/season.dart';
import '../models/top_anime.dart';

class AnimeService {
  static const _baseUrl = "http://localhost/animes";

  static Future<List<Anime>> search(String token, String letter, String filter) async {
    final http.Response response;
    if (filter == "") {
      response = await http.get(
        Uri.parse("$_baseUrl/search?letter=$letter"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $token'
        },
      );
    } else {
      response = await http.get(
        Uri.parse("$_baseUrl/search?type=$filter&letter=$letter"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'bearer $token'
        },
      );
    }
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
    final List<Anime> animes = [];
    for (final animeJson in jsonBody['animes']) {
      animes.add(Anime.fromJson(animeJson));
    }
    return animes;
  }

  static Future<List<TopAnime>> getTopAnime(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/top"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $token'
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
    final List<TopAnime> animes = [];
    for (final animeJson in jsonBody['animes']) {
      animes.add(TopAnime.fromJson(animeJson));
    }
    return animes;
  }

  static Future<List<Season>> getSeasonNow(String token) async {
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(
      Uri.parse("$_baseUrl/seasons/now"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $token'
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
    for (final animeJson in jsonBody['animes']) {
      animes.add(Season.fromJson(animeJson));
    }
    return animes;
  }

  static Future<Anime> getAnimeById(String token, String id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $token'
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
    final Anime anime = Anime.fromJson(jsonBody);
    return anime;
  }

  static Future<List<Episode>> getAnimeEpisodes(String token, String id) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$id/episodes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $token'
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
    final List<Episode> episodes = [];
    for (final episodeJson in jsonBody['data']) {
      episodes.add(Episode.fromJson(episodeJson));
    }
    return episodes;
  }
}
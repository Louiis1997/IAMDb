import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/common/storage.utils.dart';

import '../models/rating.dart';

class RatingService {
  static const _baseUrl = "http://localhost/ratings";

  static Future<List<Rating>> getRatings(String token) async {
    final response = await http.get(
      Uri.parse(_baseUrl),
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
    final List<Rating> ratings = [];
    for (final ratingJson in jsonBody) {
      ratings.add(Rating.fromJson(ratingJson));
    }
    return ratings;
  }

  static Future rate(int id, double rate) async {
    final token = await StorageUtils.getAuthToken();
    final response = await http.post(
      Uri.parse("$_baseUrl/anime/$id/rate"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $token'
      },
      body: jsonEncode(<String, double>{
        'rating': rate,
      }),
    );
    if (response.statusCode != 201) {
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
  }

  static Future<List<Rating>> getUserRatings(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/user-ratings"),
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
    final List<Rating> ratings = [];
    for (final ratingJson in jsonBody) {
      ratings.add(Rating.fromJson(ratingJson));
    }
    return ratings;
  }

  static Future<double> getUserRatingByAnimeId(int animeId) async {
    final token = await StorageUtils.getAuthToken();
    final response = await http.get(
      Uri.parse("$_baseUrl/user-ratings/anime/$animeId/rating"),
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
    return double.parse(response.body);
  }
}

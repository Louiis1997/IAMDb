import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/rating.dart';

class RatingService {
  static const _baseUrl = "http://localhost/ratings";

  static Future<List<Rating>> getRatings(String token) async {
    final response = await http.get(
      Uri.parse(_baseUrl),
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
    final List<Rating> ratings = [];
    for (final ratingJson in jsonBody) {
      ratings.add(Rating.fromJson(ratingJson));
    }
    return ratings;
  }

  static Future updateRating(String token, String id, double newRating) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/anime/$id/rate"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'bearer $token'
      },
      body: jsonEncode(<String, double>{
        'rating': newRating,
      }),
    );
    if (response.statusCode != 201) {
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
  }

  static Future<List<Rating>> getUserRatings(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/user-ratings"),
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
    final List<Rating> ratings = [];
    for (final ratingJson in jsonBody) {
      ratings.add(Rating.fromJson(ratingJson));
    }
    return ratings;
  }
}
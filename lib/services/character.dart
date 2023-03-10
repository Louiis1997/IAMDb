import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/common/storage.utils.dart';

import '../models/character.dart';

class CharacterService {
  static const _baseUrl = "http://localhost/characters";

  static Future<List<Character>> getCharacters(int id) async {
    final token = await StorageUtils.getAuthToken();
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(
      Uri.parse("$_baseUrl/anime/$id"),
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
    final List<Character> characters = [];
    for (final characterJson in jsonBody['data']) {
      characters.add(Character.fromJson(characterJson));
    }
    return characters;
  }

  static Future<Character> getCharacterById(String token, String id) async {
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
    final Character character = Character.fromJson(jsonBody['data']);
    return character;
  }
}

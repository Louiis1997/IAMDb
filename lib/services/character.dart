import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharacterService {
  static const _baseUrl = "http://localhost/characters";

  Future<List<Character>> getCharacters(String token, String id) async {
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
    final List<Character> characters = [];
    for (final characterJson in jsonBody['data']['character']) {
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
    final Character character = Character.fromJson(jsonBody['data']);
    return character;
  }
}

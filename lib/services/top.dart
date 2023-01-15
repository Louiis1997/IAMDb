import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/top.dart';

class TopService {
  final _baseUrl = "https://api.jikan.moe/v4/top";

  Future<Top> getTopAnime() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/anime"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Top.fromJson(responseData);
      }
      String jsonError = jsonDecode(response.body)["error"].source;
      throw Exception(jsonError);
    } catch (err) {
      throw Exception(err);
    }
  }
}
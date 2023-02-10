import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/models/agenda.dart';

class AgendaService {
  static const _baseUrl = "http://localhost/agendas";

  static Future<List<Agenda>> getAgenda(String token) async {
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
    final List<Agenda> agendas = [];
    for (final agendaJson in jsonBody) {
      agendas.add(Agenda.fromJson(agendaJson));
    }
    return agendas;
  }

  static Future updateAgendaStatus(String token, int id, String status) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/anime/$id/$status"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'bearer $token'
      },
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

  static Future<List<Agenda>> getAgendaByStatus(
      String token, String status) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$status"),
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
    final List<Agenda> agendas = [];
    for (final agendaJson in jsonBody) {
      agendas.add(Agenda.fromJson(agendaJson));
    }
    return agendas;
  }

  static Future<String> getAnimeStatus(String token, String animeId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/anime/$animeId/status"),
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
    return response.body;
  }

  static Future deleteAnimeStatus(String token, String animeId) async {
    final response = await http.delete(
      Uri.parse("$_baseUrl/anime/$animeId/remove"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $token'
      },
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
}

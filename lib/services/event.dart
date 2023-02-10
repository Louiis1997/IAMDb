import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/event.dart';

class EventService {
  static const _baseUrl = "http://localhost/events";

  static Future<List<Event>> getPastEvents(String token) async {
    return getEventsByStatus(token, "past");
  }

  static Future<List<Event>> getLiveEvents(String token) async {
    return getEventsByStatus(token, "live");
  }

  static Future<List<Event>> getUpcomingEvents(String token) async {
    return getEventsByStatus(token, "upcoming");
  }

  static Future<List<Event>> getEventsByStatus(
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
    final List<Event> events = [];
    for (final eventJson in jsonBody) {
      events.add(Event.fromJson(eventJson));
    }
    return events;
  }
}

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
          throw Exception('Bad request when getting $status events');
        case 404:
          throw Exception('Not Found');
        case 429:
          throw Exception('Too Many Requests');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
        default:
          throw Exception('Unknown error when getting $status events');
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

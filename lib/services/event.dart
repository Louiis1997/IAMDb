import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/common/storage.utils.dart';
import 'package:iamdb/exceptions/not-found.exception.dart';

import '../exceptions/events/event-duplicate.exception.dart';
import '../exceptions/unauthorized.exception.dart';
import '../models/event.dart';

class EventService {
  static const _baseUrl = "http://localhost/events";

  static Future<Event> create({
    required String eventName,
    required String eventDescription,
    required String eventCategory,
    required String eventOrganizer,
    required String eventAddress,
    required String eventCity,
    required String eventZipCode,
    required String eventCountry,
    required DateTime eventStartDate,
    required DateTime? eventEndDate,
    required double eventLatitude,
    required double eventLongitude,
  }) async {
    String body = jsonEncode(<String, dynamic>{
      'name': eventName,
      'description': eventDescription,
      'category': eventCategory,
      'organizer': eventOrganizer,
      'city': eventCity,
      'address': eventAddress,
      'zipCode': eventZipCode,
      'country': eventCountry,
      'latitude': eventLatitude,
      'longitude': eventLongitude,
      'startDate': eventStartDate.toIso8601String(),
      'endDate': eventEndDate != null ? eventEndDate.toIso8601String() : null,
    });
    final token = await StorageUtils.getAuthToken();
    final response = await http.post(
      Uri.parse("$_baseUrl"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $token'
      },
      body: body,
    );
    if (response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Missing required fields');
        case 401:
          throw UnauthorizedException('You are not logged in');
        case 404:
          throw Exception('Not Found');
        case 409:
          throw EventDuplicateException('Event already exists with this name');
        case 429:
          throw Exception('Too Many Request');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final jsonBody = json.decode(response.body);
    return Event.fromJson(jsonBody);
  }

  static Future<List<Event>> getPastEvents() async {
    return getEventsByStatus("past");
  }

  static Future<List<Event>> getLiveEvents() async {
    return getEventsByStatus("live");
  }

  static Future<List<Event>> getUpcomingEvents() async {
    return getEventsByStatus("upcoming");
  }

  static Future<List<Event>> getEventsByStatus(String status) async {
    final token = await StorageUtils.getAuthToken();
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

  static Future<void> cancelEvent(String eventId) async {
    final token = await StorageUtils.getAuthToken();
    final response = await http.patch(
      Uri.parse("$_baseUrl/$eventId/cancel"),
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
          throw UnauthorizedException('You are not logged in');
        case 404:
          throw NotFoundException('Event not found');
        case 429:
          throw Exception('429: Too Many Request');
        case 500:
          throw Exception('500: Internal Server Error');
        case 503:
          throw Exception('503: Service Unavailable');
      }
    }
  }

  static Future<void> deleteEvent(String eventId) async {
    final token = await StorageUtils.getAuthToken();
    final response = await http.delete(
      Uri.parse("$_baseUrl/$eventId"),
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
          throw UnauthorizedException('You are not logged in');
        case 404:
          throw NotFoundException('Event not found');
        case 429:
          throw Exception('429: Too Many Request');
        case 500:
          throw Exception('500: Internal Server Error');
        case 503:
          throw Exception('503: Service Unavailable');
      }
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iamdb/models/user.dart';

class UserService {
  static const _baseUrl = "http://localhost/users";

  static Future<User> getUser(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/profile"),
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
    final User user = User.fromJson(jsonBody);
    return user;
  }

  static Future<User> getUserByEmail(String token, String email) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/{email}?email=$email"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'bearer $token'
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
    final User user = User.fromJson(jsonBody);
    return user;
  }

  static Future<User> updateUser(
      String token,
      String username,
      String firstname,
      String lastname,
      String email,
      String bio,
      String birthday,
      String status) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/profile/update"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'bearer $token'
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'bio': bio,
        'birthday': birthday,
        'status': status
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
    final jsonBody = json.decode(response.body);
    final User user = User.fromJson(jsonBody);
    return user;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';

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
    final User user = User.fromJson(jsonBody);
    return user;
  }

  static Future<void> updateUser(
    String  token,
    String username,
    String firstname,
    String lastname,
    String bio,
    String birthdate,
    String status,
  ) async {
    final request =
        http.MultipartRequest('PATCH', Uri.parse("$_baseUrl/profile"));
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    request.headers['authorization'] = 'bearer $token';
    if (username != null && username.isNotEmpty)
      request.fields['username'] = username;
    if (firstname != null && firstname.isNotEmpty)
      request.fields['firstName'] = firstname;
    if (lastname != null && lastname.isNotEmpty)
      request.fields['lastName'] = lastname;
    if (bio != null && bio.isNotEmpty) request.fields['bio'] = bio;
    if (birthdate != null && birthdate.isNotEmpty)
      request.fields['birthdate'] = birthdate;
    if (status != null && status.isNotEmpty) request.fields['status'] = status;
    final response = await request.send();
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
  }

  static Future updatePassword(String oldPassword, String newPassword) async {
    final response = await http.patch(
      Uri.parse("$_baseUrl/update-password"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'oldPassword': oldPassword,
        'newPassword': newPassword
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

  static Future delete(String token) async {
    final response = await http.delete(
      Uri.parse("$_baseUrl/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'bearer $token'
      },
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
}

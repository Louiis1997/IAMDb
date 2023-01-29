import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = "http://localhost/auth";

  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': email,
        'password': password
      }),
    );
    if (response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request');
        case 404:
          throw Exception('Not Found');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final responseData = json.decode(response.body);
    return responseData;
  }

  static Future register(String username, String firstname, String lastname,
      String email, String password, String bio, String birthdate, String status) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username": username,
        "firstName": firstname,
        "lastName": lastname,
        "email": email,
        "password": password,
        "bio": bio,
        "birthdate": birthdate,
        "status": status
      }),
    );
    if (response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request');
        case 404:
          throw Exception('Not Found');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final responseData = json.decode(response.body);
    return responseData;
  }

  static Future updatePassword(String email, String oldPassword,
      String newPassword) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/update-password"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'oldPassword': oldPassword,
        'newPassword': newPassword
      }),
    );
    if (response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request');
        case 404:
          throw Exception('Not Found');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final responseData = json.decode(response.body);
    return responseData;
  }
}

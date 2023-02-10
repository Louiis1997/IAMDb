import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:iamdb/exceptions/not-found.exception.dart';
import 'package:iamdb/exceptions/unauthorized.exception.dart';

class AuthService {
  static const _baseUrl = "http://localhost/auth";

  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'username': email, 'password': password}),
    );
    if (response.statusCode != 201) {
      switch (response.statusCode) {
        case 400:
          throw Exception('Bad request');
        case 401:
          throw UnauthorizedException('Unauthorized');
        case 404:
          throw NotFoundException('Not Found');
        case 500:
          throw Exception('Internal Server Error');
        case 503:
          throw Exception('Service Unavailable');
      }
    }
    final responseData = json.decode(response.body);
    return responseData;
  }

  static Future register(
      String username,
      String firstname,
      String lastname,
      String email,
      String password,
      String bio,
      String birthdate,
      String status,
      File? image) async {
    final request =
        http.MultipartRequest('POST', Uri.parse("$_baseUrl/register"));
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
    }
    request.fields['username'] = username;
    request.fields['firstName'] = firstname;
    request.fields['lastName'] = lastname;
    request.fields['email'] = email;
    request.fields['password'] = password;
    if (bio != "") request.fields['bio'] = bio;
    if (birthdate != "") request.fields['birthdate'] = birthdate;
    if (status != "") request.fields['status'] = status;
    final response = await request.send();
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
    var responseData = await http.Response.fromStream(response);
    return json.decode(responseData.body);
  }
}

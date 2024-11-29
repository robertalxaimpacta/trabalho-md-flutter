import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:aula_flutter_full08/models/user.dart';
import 'package:localstorage/localstorage.dart';


class _AuthService {

  final String _baseUrl = 'http://192.168.15.58:3030/auth/login';
  final String _sessionKey = 'auth@SESSION_KEY';

  User? getSession() {
    var json = localStorage.getItem(_sessionKey);
    if (json == null) return null;

    dynamic obj = jsonDecode(json);
    return User.fromObject(obj);
  }

  void _setSession(User user) {
    String json = jsonEncode(user.toObject());
    localStorage.setItem(_sessionKey, json);
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({ 'username': username, 'password': password })
    );

    if (response.statusCode == 201) {
      dynamic obj = jsonDecode(response.body);
      final user = User.fromObject(obj);

      _setSession(user);
      return true;
    }
    return false;
  }
}

final authService = _AuthService();
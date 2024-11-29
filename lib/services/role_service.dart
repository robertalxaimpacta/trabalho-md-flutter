import 'dart:convert';

import 'package:aula_flutter_full08/models/role.dart';
import 'package:aula_flutter_full08/models/user.dart';
import 'package:aula_flutter_full08/services/auth_service.dart';
import 'package:http/http.dart' as http;

class _RoleService {
  final String _baseUrl = 'http://192.168.15.58:3030/roles';

  Map<String, String> _getHeaders() {
    User? session = authService.getSession();
    if (session == null || session.token == null)
      throw Exception('Sessão expirada!');

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${session.token}'
    };
  }

  Future<List<Role>> getList() async {
    final response =
        await http.get(Uri.parse(_baseUrl), headers: _getHeaders());

    if (response.statusCode == 200) {
      List<dynamic> list = List.from(jsonDecode(response.body));
      List<Role> roles = list.map((e) => Role.fromObject(e)).toList();
      return roles;
    }

    throw Exception('Sessão expirada!');
  }

  Future<bool> create(Role role) async {
    final response = await http.post(Uri.parse(_baseUrl),
        headers: _getHeaders(), body: jsonEncode(role.toObject()));

    if (response.statusCode == 201) {
      dynamic obj = jsonDecode(response.body);
      Role role = Role.fromObject(obj);
      return (role.id != null);
    } else if (response.statusCode != 400) {
      throw Exception('Sessão expirada!');
    }

    return false;
  }

  Future<bool> delete(Role role) async {
    final roleId = role.id;
    final response = await http.delete(
      Uri.parse('$_baseUrl/$roleId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200 && response.body == 'true') {
      return (true);
    } else if (response.statusCode != 400) {
      throw Exception('Sessão expirada!');
    }

    return false;
  }
}

final roleService = _RoleService();

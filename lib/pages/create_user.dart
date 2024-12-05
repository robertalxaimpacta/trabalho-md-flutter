import 'dart:developer';
import 'package:aula_flutter_full08/components/my_button.dart';
import 'package:aula_flutter_full08/models/role.dart';
import 'package:aula_flutter_full08/services/role_service.dart';
import 'package:aula_flutter_full08/components/my_input.dart';
import 'package:aula_flutter_full08/models/user.dart';
import 'package:aula_flutter_full08/pages/login.dart';
import 'package:aula_flutter_full08/services/user_service.dart';
import 'package:aula_flutter_full08/util.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  String _name = '';
  String _username = '';
  String _password = '';
  String _confirmPass = '';
  List<String> _selectedRoles = [];
  List<Role> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final rolesList = await getListRoles(context); // Busca os papéis
      setState(() {
        _roles = rolesList;
        _isLoading = false;
      });
    } catch (e) {
      log('Erro ao carregar roles: $e');
      Navigator.pop(context); // Retorna caso haja um erro
    }
  }
  
  Future<List<Role>> getListRoles(BuildContext context) async {
    try {
      return await roleService.getList();
    } catch (error) {
      Navigator.pop(context);
    }
    return [];
  }

  void save() {
    if (_name.trim() == '') {
      Util.alert(context, 'Nome é obrigatório!');
      return;
    }
    if (_username.trim() == '') {
      Util.alert(context, 'Login é obrigatório!');
      return;
    }
    if (_password.trim() == '') {
      Util.alert(context, 'Senha é obrigatória!');
      return;
    }
    if (_password != _confirmPass) {
      Util.alert(context, 'Senha não confere!');
      return;
    }
    if (_selectedRoles.isEmpty) {
      Util.alert(context, 'Selecione uma role!');
      return;
    }

    final User user = User(null, _name, _username, _password, _selectedRoles);
    
    userService.create(user).then((isSaved) {
      if (isSaved) {
        Navigator.pop(context);
      } else {
        Util.alert(context, 'Usuário já existe!');
      }
    }).catchError((error) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Usuário')),
      body: Column(
        children: [
          MyInput(label: 'Nome', change: (String value) => _name = value),
          MyInput(label: 'Login', change: (String value) => _username = value),
          MyInput(
              label: 'Senha',
              obscureText: true,
              change: (String value) => _password = value),
          MyInput(
              label: 'Confirmar Senha',
              obscureText: true,
              change: (String value) => _confirmPass = value),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecione as Roles:',
                  style: TextStyle(fontSize: 16),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _roles.map((role) {
                    return FilterChip(
                      label: Text(role.name),
                      selected: _selectedRoles.contains(role.name),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedRoles.add(role.name);
                          } else {
                            _selectedRoles.remove(role.name);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          MyButton(text: 'Salvar', onPress: save)
        ],
      ),
    );
  }
}

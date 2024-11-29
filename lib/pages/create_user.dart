import 'dart:developer';
import 'package:aula_flutter_full08/components/my_button.dart';
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

    final User user = User(null, _name, _username, _password);
    
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
          MyButton(text: 'Salvar', onPress: save)
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'package:aula_flutter_full08/components/my_button.dart';
import 'package:aula_flutter_full08/components/my_input.dart';
import 'package:aula_flutter_full08/models/role.dart';
import 'package:aula_flutter_full08/models/user.dart';
import 'package:aula_flutter_full08/pages/login.dart';
import 'package:aula_flutter_full08/services/role_service.dart';
import 'package:aula_flutter_full08/services/user_service.dart';
import 'package:aula_flutter_full08/util.dart';
import 'package:flutter/material.dart';

class CreateRolePage extends StatefulWidget {
  const CreateRolePage({super.key});

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  String _name = '';
  String _description = '';

  void save() {
    if (_name.trim() == '') {
      Util.alert(context, 'Nome é obrigatório!');
      return;
    }
    if (_description.trim() == '') {
      Util.alert(context, 'Descrição é obrigatória!');
      return;
    }

    final Role role = Role(null, _name, _description);

    roleService.create(role).then((isSaved) {
      if (isSaved) {
        Navigator.pop(context);
      } else {
        Util.alert(context, 'Não foi possível inserir role!');
      }
    }).catchError((error) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Role')),
      body: Column(
        children: [
          MyInput(label: 'Nome', change: (String value) => _name = value),
          MyInput(
              label: 'Descrição', change: (String value) => _description = value),
          MyButton(text: 'Salvar', onPress: save)
        ],
      ),
    );
  }
}

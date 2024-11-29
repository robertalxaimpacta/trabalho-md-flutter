import 'dart:developer';
import 'package:aula_flutter_full08/components/my_button.dart';
import 'package:aula_flutter_full08/components/my_input.dart';
import 'package:aula_flutter_full08/models/user.dart';
import 'package:aula_flutter_full08/services/user_service.dart';
import 'package:aula_flutter_full08/util.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final User user;

  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late String _name;
  late String _username;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _username = widget.user.username;
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

    final User updatedUser = User(widget.user.id, _name, _username, widget.user.password);
    
    userService.update(updatedUser).then((isSaved) {
      if (isSaved) {
        Navigator.pop(context, updatedUser);
      } else {
        Util.alert(context, 'Não foi possível salvar!');
      }
    }).catchError((error) {
      print("Error while saving user: $error");
      Util.alert(context, 'Erro ao salvar o usuário. Tente novamente mais tarde.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyInput(
              label: 'Nome',
              initialValue: _name,
              change: (String value) => setState(() => _name = value),
            ),
            MyInput(
              label: 'Username',
              initialValue: _username,
              change: (String value) => setState(() => _username = value),
            ),
            const SizedBox(height: 16),
            MyButton(text: 'Salvar', onPress: save),
          ],
        ),
      ),
    );
  }
}

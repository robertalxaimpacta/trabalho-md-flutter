import 'dart:developer';
import 'package:aula_flutter_full08/components/my_button.dart';
import 'package:aula_flutter_full08/models/role.dart';
import 'package:aula_flutter_full08/services/role_service.dart';
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
  List<String> _selectedRoles = [];
  List<Role> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _username = widget.user.username;
    _selectedRoles = List.from(widget.user.roles ?? []);
    _loadRoles();
  }

    Future<void> _loadRoles() async {
    try {
      final rolesList = await getListRoles(context);
      setState(() {
        _roles = rolesList;
        print('Roles disponíveis: ${_roles.map((r) => r.name)}');
        print('Roles selecionadas: $_selectedRoles');
        _isLoading = false;
      });
    } catch (e) {
      log('Erro ao carregar roles: $e');
      Navigator.pop(context);
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
    if (_selectedRoles.isEmpty) {
      Util.alert(context, 'Selecione uma Role!');
      return;
    }

    final User updatedUser = User(widget.user.id, _name, _username, widget.user.password, _selectedRoles);
    
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
            const SizedBox(height: 16),
            MyButton(text: 'Salvar', onPress: save),
          ],
        ),
      ),
    );
  }
}

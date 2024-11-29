import 'package:aula_flutter_full08/models/role.dart';
import 'package:aula_flutter_full08/pages/create_role.dart';
import 'package:aula_flutter_full08/pages/login.dart';
import 'package:aula_flutter_full08/services/role_service.dart';
import 'package:aula_flutter_full08/util.dart';
import 'package:flutter/material.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  Future<List<Role>> fetchRoles(BuildContext context) async {
    try {
      return await roleService.getList();
    } catch (error) {
      Navigator.pop(context);
    }
    return [];
  }

  void goToCreateRole(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateRolePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment_add),
            onPressed: () => goToCreateRole(context),
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchRoles(context),
          builder: (context, snapshot) {
            List<Role> roles = snapshot.data ?? [];
            return RefreshIndicator(
              onRefresh: () {
                setState(() {});
                return Future.value();
              },
              child: _buildListRoles(roles),
            );
          }),
    );
  }

  void deleteRole(Role role) {
    roleService.delete(role).then((wasRemoved) {
      if (wasRemoved) {
        setState(() {});
      } else {
        Util.alert(context, 'Não foi possível remover o role!');
      }
    }).catchError((error) {
      print(error);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  ListView _buildListRoles(List<Role> roles) {
    return ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          Role role = roles[index];

          return Dismissible(
              background: Container(
                color: Colors.red,
              ),
              key: UniqueKey(),
              child: ListTile(
                title: Text(role.name),
                subtitle: Text(role.description),
              ),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  deleteRole(roles[index]);
                });
              });
        });
  }
}

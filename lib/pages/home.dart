import 'package:aula_flutter_full08/models/user.dart';
import 'package:aula_flutter_full08/pages/create_user.dart';
import 'package:aula_flutter_full08/pages/login.dart';
import 'package:aula_flutter_full08/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:aula_flutter_full08/util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> fetchUsers(BuildContext context) async {
    try {
      return await userService.getList();
    } catch (error) {
      Navigator.pop(context);
    }
    return [];
  }

  void goToCreateUser(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CreateUserPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => goToCreateUser(context),
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchUsers(context),
          builder: (context, snapshot) {
            List<User> users = snapshot.data ?? [];
            return RefreshIndicator(
              onRefresh: () {
                setState(() {});
                return Future.value();
              },
              child: _buildListUsers(users),
            );
          }),
    );
  }

  ListView _buildListUsers(List<User> users) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];

          return Dismissible(
              background: Container(
                color: Colors.red,
              ),
              key: UniqueKey(),
              child: ListTile(
                title: Text(user.name),
                subtitle: Text(user.username),
              ),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  userService.delete(users[index]).then((wasRemoved) {
                    if (wasRemoved) {
                      setState(() {});
                    } else {
                      Util.alert(
                          context, 'Não foi possível remover o usuário!');
                    }
                  }).catchError((error) {
                    print(error);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                  });
                });
              });
        });
  }
}

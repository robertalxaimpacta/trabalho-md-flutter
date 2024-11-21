import 'package:aula_flutter_full08/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main() async {
  await initLocalStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const LoginPage(),
    );
  }
}
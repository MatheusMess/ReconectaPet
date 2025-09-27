import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'tela_apresentacao.dart';
=======
import 'tela_login.dart';
>>>>>>> f7ca8a5306a1afee2ed8ba2e57e75633d517d34c

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      home: const TelaApresentacao(),
=======
      home: const TelaLogin(),
>>>>>>> f7ca8a5306a1afee2ed8ba2e57e75633d517d34c
    );
  }
}

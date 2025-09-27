import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_criar_conta.dart';
import 'tela_principal.dart';
import 'tela_cadastro_animal.dart';
<<<<<<< HEAD
import 'tela_apresentacao.dart';

class Navegacao {
  // Vai para a tela de apresentação
  static void irParaApresentacao(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaApresentacao()),
    );
  }

=======

class Navegacao {
>>>>>>> f7ca8a5306a1afee2ed8ba2e57e75633d517d34c
  // Vai para a tela de login
  static void irParaLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
    );
  }

  // Vai para a tela de criar conta
  static void irParaCriarConta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaCriarConta()),
    );
  }

<<<<<<< HEAD
  // Vai para a tela principal
=======
  // Vai para a tela principal (lista de animais perdidos)
>>>>>>> f7ca8a5306a1afee2ed8ba2e57e75633d517d34c
  static void irParaTelaPrincipal(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaPrincipal()),
    );
  }

  // Vai para a tela de cadastro de animal
  static void irParaCadastroAnimal(
    BuildContext context,
    void Function(String nome, String descricao) onSalvar,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroAnimal(onSalvar: onSalvar),
      ),
    );
  }
}

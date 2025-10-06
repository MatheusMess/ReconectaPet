import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_criar_conta.dart';
import 'tela_principal.dart';
import 'tela_cadastro_animal.dart';
import 'tela_apresentacao.dart';

class Navegacao {
  // Vai para a tela de apresentação
  static void irParaApresentacao(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TelaApresentacao()),
    );
  }

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

  // Vai para a tela principal
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

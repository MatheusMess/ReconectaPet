import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_criar_conta.dart';
import 'tela_principal.dart';
import 'tela_cadastro_animal_perdido.dart';
import 'tela_apresentacao.dart';
import 'tela_detalhes_animal.dart';
import 'animal.dart';
import 'autenticacao.dart';
import 'tela_esqueceu_senha.dart';
import 'tela_editar_perfil.dart';
import 'tela_configuracoes_notificacao.dart';
import 'tela_codigo_recuperacao.dart';
import 'tela_nova_senha.dart';

class Navegacao {
  // Vai para a tela de apresentação
  static void irParaApresentacao(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaApresentacao()),
      (route) => false,
    );
  }

  // Vai para a tela de login
  static void irParaLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaPrincipal()),
      (route) => false,
    );
  }

  // Vai para a tela de cadastro de animal perdido
  static void irParaCadastroAnimalPerdido(
    BuildContext context,
    void Function(Animal) onSalvar,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroAnimalPerdido(onSalvar: onSalvar),
      ),
    );
  }

  // Vai para a tela de detalhes do animal
  static void irParaDetalhesAnimal(BuildContext context, Animal animal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesAnimal(animal: animal),
      ),
    );
  }

  // Faz logout e vai para a tela de login
  // No arquivo navegacao.dart - método fazerLogout
  static void fazerLogout(BuildContext context) {
    AuthService().logout();
    AuthService.limparLoginSalvo(); // Agora chama do AuthService
    irParaLogin(context);
  }

  // Volta para a tela anterior
  static void voltar(BuildContext context) {
    Navigator.pop(context);
  }

  // Vai para a tela de cadastro de animal encontrado (para implementação futura)
  static void irParaCadastroAnimalEncontrado(
    BuildContext context,
    void Function(Animal) onSalvar,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroAnimalPerdido(onSalvar: onSalvar),
      ),
    );
  }

  // Navegação com resultado
  static Future<T?> irParaTelaComResultado<T>(
    BuildContext context,
    Widget tela,
  ) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
  }

  // Remove todas as telas e vai para a principal
  static void irParaTelaPrincipalAposLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaPrincipal()),
      (route) => false,
    );
  }

  // Navegação para telas de edição (para implementação futura)
  /* static void irParaEditarAnimal(
    BuildContext context,
    Animal animal,
    void Function(Animal) onSalvar,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCadastroAnimalPerdido(
          onSalvar: onSalvar,
          animalParaEditar: animal,
        ),
      ),
    );
  }
  */

  // Navegação para configurações (para implementação futura)
  static void irParaConfiguracoes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Configurações'),
            backgroundColor: Colors.cyan,
          ),
          body: const Center(
            child: Text('Tela de Configurações em desenvolvimento'),
          ),
        ),
      ),
    );
  }

  // Navegação para ajuda (para implementação futura)
  static void irParaAjuda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Ajuda'),
            backgroundColor: Colors.cyan,
          ),
          body: const Center(
            child: Text('Central de Ajuda em desenvolvimento'),
          ),
        ),
      ),
    );
  }

  // Navegação para sobre (para implementação futura)
  static void irParaSobre(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Sobre'),
            backgroundColor: Colors.cyan,
          ),
          body: const Center(
            child: Text('Sobre o ReconectaPet em desenvolvimento'),
          ),
        ),
      ),
    );
  }

  // Vai para a tela de esqueceu a senha
  static void irParaEsqueceuSenha(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaEsqueceuSenha()),
    );
  }

  // Vai para a tela de editar perfil
  static void irParaEditarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaEditarPerfil()),
    );
  }

  // Vai para a tela de configurações de notificação
  static void irParaConfiguracoesNotificacao(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaConfiguracoesNotificacao(),
      ),
    );
  }

  // Vai para a tela de código de recuperação
  static void irParaCodigoRecuperacao(BuildContext context, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaCodigoRecuperacao(email: email),
      ),
    );
  }

  // Vai para a tela de nova senha
  static void irParaNovaSenha(BuildContext context, String email) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaNovaSenha(email: email)),
    );
  }

  // Método para mostrar dialogs
  static Future<T?> mostrarDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  // Método para mostrar bottom sheets
  static Future<T?> mostrarBottomSheet<T>(
    BuildContext context, {
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => child,
    );
  }
}

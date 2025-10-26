import 'package:flutter/material.dart';
import 'autenticacao.dart';
import 'fundo_patinha_aleatoria.dart';
import 'tela_login.dart';

class TelaNovaSenha extends StatefulWidget {
  final String email;

  const TelaNovaSenha({super.key, required this.email});

  @override
  State<TelaNovaSenha> createState() => _TelaNovaSenhaState();
}

class _TelaNovaSenhaState extends State<TelaNovaSenha> {
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  void _redefinirSenha() async {
    if (_senhaController.text.isEmpty ||
        _confirmarSenhaController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos');
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      _mostrarErro('As senhas não coincidem');
      return;
    }

    if (_senhaController.text.length < 6) {
      _mostrarErro('A senha deve ter pelo menos 6 caracteres');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final sucesso = await _authService.redefinirSenha(
        widget.email,
        _senhaController.text,
      );

      if (sucesso) {
        _mostrarSucesso('Senha redefinida com sucesso!');
        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TelaLogin()),
          (route) => false,
        );
      }
    } catch (e) {
      _mostrarErro(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FundoPatinhaAleatoria(
        tileHeight: 120,
        tileWidth: 120,
        tileAssetPaths: ['assets/patas.png', 'assets/nada.png'],
        stackChildren: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Nova Senha",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Crie uma nova senha para sua conta",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 40),

                    _campoSenha("Nova Senha", Icons.lock, _senhaController),
                    const SizedBox(height: 15),
                    _campoSenha(
                      "Confirmar Senha",
                      Icons.lock,
                      _confirmarSenhaController,
                      isConfirmacao: true,
                    ),
                    const SizedBox(height: 30),

                    _carregando
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _redefinirSenha,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.cyan,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Redefinir Senha",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Voltar",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/cachorro2.png",
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoSenha(
    String label,
    IconData icone,
    TextEditingController controller, {
    bool isConfirmacao = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isConfirmacao ? !_confirmarSenhaVisivel : !_senhaVisivel,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icone, color: Colors.white70),
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmacao
                ? (_confirmarSenhaVisivel
                      ? Icons.visibility
                      : Icons.visibility_off)
                : (_senhaVisivel ? Icons.visibility : Icons.visibility_off),
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              if (isConfirmacao) {
                _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
              } else {
                _senhaVisivel = !_senhaVisivel;
              }
            });
          },
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'autenticacao.dart';
import 'fundo_patinha_aleatoria.dart';
import 'tela_codigo_recuperacao.dart';
import 'navegacao.dart';

class TelaEsqueceuSenha extends StatefulWidget {
  const TelaEsqueceuSenha({super.key});

  @override
  State<TelaEsqueceuSenha> createState() => _TelaEsqueceuSenhaState();
}

class _TelaEsqueceuSenhaState extends State<TelaEsqueceuSenha> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  bool _emailEnviado = false;

  void _solicitarRecuperacao() async {
    if (_emailController.text.isEmpty) {
      _mostrarErro('Digite seu email');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final sucesso = await _authService.solicitarRecuperacaoSenha(
        _emailController.text,
      );

      if (sucesso) {
        setState(() {
          _emailEnviado = true;
        });
        _mostrarSucesso('Código enviado para seu email!');
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
                      "Recuperar Senha",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Digite seu email para receber o código de recuperação",
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),

                    if (!_emailEnviado) ...[
                      _campoEmail(),
                      const SizedBox(height: 30),

                      _carregando
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _solicitarRecuperacao,
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
                                  "Enviar Código",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ] else ...[
                      const Icon(
                        Icons.mark_email_read,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Código Enviado!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enviamos um código de 6 dígitos para:\n${_emailController.text}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TelaCodigoRecuperacao(
                                  email: _emailController.text,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Inserir Código",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _emailEnviado = false;
                          });
                        },
                        child: const Text(
                          "Reenviar código",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navegacao.irParaLogin(context);
                      },
                      child: const Text(
                        "Voltar para o Login",
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

  Widget _campoEmail() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        labelText: "Email",
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.email, color: Colors.white70),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

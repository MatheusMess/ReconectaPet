import 'package:flutter/material.dart';
import 'navegacao.dart';
import 'fundo_patinha_aleatoria.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // teclado por cima
      body: FundoPatinhaAleatoria(
        tileHeight: 120,
        tileWidth: 120,
        tileAssetPaths: ['assets/patas.png', 'assets/nada.png'],
        stackChildren: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "ReconectaPet",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  _campoTexto("E-mail", Icons.email),
                  const SizedBox(height: 15),
                  _campoSenha("Senha", Icons.lock),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navegacao.irParaCriarConta(context);
                        },
                        child: const Text(
                          "Criar conta",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Esqueceu a senha?",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  OutlinedButton(
                    onPressed: () {
                      Navegacao.irParaTelaPrincipal(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 100,
                      ),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      foregroundColor: Colors.cyan,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 10),
                        Image.asset("assets/google.png", height: 24),
                        const SizedBox(width: 12),
                        const Text(
                          "Login com Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Cachorro sempre embaixo
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/cachorro1.png",
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(String label, IconData icone) {
    return TextField(
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
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _campoSenha(String label, IconData icone) {
    return TextField(
      obscureText: true,
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
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}

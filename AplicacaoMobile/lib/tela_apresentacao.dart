import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_criar_conta.dart';
import 'fundo_patinha_aleatoria.dart';

class TelaApresentacao extends StatefulWidget {
  const TelaApresentacao({super.key});

  @override
  State<TelaApresentacao> createState() => _TelaApresentacaoState();
}

class _TelaApresentacaoState extends State<TelaApresentacao> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;

  final List<Map<String, String>> _paginas = [
    {
      "imagem": "assets/apresentacao1.png",
      "titulo": "Encontre seu pet",
      "descricao":
          "Nosso app ajuda você a localizar animais perdidos na sua cidade.",
    },
    {
      "imagem": "assets/apresentacao2.jpg",
      "titulo": "Conecte-se",
      "descricao":
          "Facilitamos a comunicação entre tutores, ONGs e quem encontrou animais.",
    },
    {
      "imagem": "assets/apresentacao3.jpg",
      "titulo": "Adote com facilidade",
      "descricao":
          "Conheça animais disponíveis para adoção e dê um novo lar a eles.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FundoPatinhaAleatoria(
        tileHeight: 120,
        tileWidth: 120,
        tileAssetPaths: ['assets/patas.png', 'assets/nada.png'],
        stackChildren: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Texto de boas-vindas
                const Text(
                  "Bem-vindo ao",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                // Logo abaixo do texto
                Image.asset("assets/logo_texto.png", height: 200),

                const SizedBox(height: 20),

                // Slider
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _paginas.length,
                    onPageChanged: (index) {
                      setState(() {
                        _paginaAtual = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final pagina = _paginas[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Imagem menor com borda branca arredondada
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                pagina["imagem"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            pagina["titulo"]!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              pagina["descricao"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _paginas.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 20,
                      ),
                      width: _paginaAtual == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _paginaAtual == index
                            ? Colors.cyan
                            : Colors.white70,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // Botões transparentes com borda branca
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TelaLogin(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Entrar",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TelaCriarConta(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          minimumSize: const Size(double.infinity, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: const Text(
                          "Criar Conta",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

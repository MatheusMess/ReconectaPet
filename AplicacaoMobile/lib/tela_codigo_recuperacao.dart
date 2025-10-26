import 'package:flutter/material.dart';
import 'autenticacao.dart';
import 'fundo_patinha_aleatoria.dart';
import 'tela_nova_senha.dart';

class TelaCodigoRecuperacao extends StatefulWidget {
  final String email;

  const TelaCodigoRecuperacao({super.key, required this.email});

  @override
  State<TelaCodigoRecuperacao> createState() => _TelaCodigoRecuperacaoState();
}

class _TelaCodigoRecuperacaoState extends State<TelaCodigoRecuperacao> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _authService = AuthService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _setupFocusNodes();
  }

  void _setupFocusNodes() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && i < _focusNodes.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  String _getCodigo() {
    return _controllers.map((controller) => controller.text).join();
  }

  void _verificarCodigo() async {
    final codigo = _getCodigo();

    if (codigo.length != 6) {
      _mostrarErro('Digite o código completo de 6 dígitos');
      return;
    }

    setState(() {
      _carregando = true;
    });

    // Pequeno delay para simular verificação
    await Future.delayed(const Duration(milliseconds: 500));

    final codigoValido = _authService.verificarCodigoRecuperacao(
      widget.email,
      codigo,
    );

    if (codigoValido) {
      _mostrarSucesso('Código verificado!');
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaNovaSenha(email: widget.email),
        ),
      );
    } else {
      _mostrarErro('Código inválido ou expirado');
    }

    setState(() {
      _carregando = false;
    });
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
        duration: const Duration(seconds: 2),
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
                      "Verificar Código",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Digite o código de 6 dígitos enviado para seu email",
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

                    // Campos do código
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: Colors.white24,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }

                              // Verificar automaticamente quando completar
                              if (index == 5 && value.isNotEmpty) {
                                final codigoCompleto = _getCodigo();
                                if (codigoCompleto.length == 6) {
                                  _verificarCodigo();
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),

                    _carregando
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _verificarCodigo,
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
                                "Verificar Código",
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

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}

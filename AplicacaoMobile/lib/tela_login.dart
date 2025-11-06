import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navegacao.dart';
import 'fundo_patinha_aleatoria.dart';
import 'autenticacao.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _manterConectado = false;

  // Chaves para SharedPreferences (agora públicas)
  static const String chaveManterConectado = 'manter_conectado';
  static const String chaveEmail = 'ultimo_email';
  static const String chaveUsuarioLogado = 'usuario_logado';

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
    _verificarLoginAutomatico();
  }

  // Carrega as preferências salvas
  Future<void> _carregarPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _manterConectado = prefs.getBool(chaveManterConectado) ?? false;
        final ultimoEmail = prefs.getString(chaveEmail);
        if (ultimoEmail != null) {
          _emailController.text = ultimoEmail;
        }
      });
    } catch (e) {
      print('Erro ao carregar preferências: $e');
    }
  }

  // Verifica se tem usuário logado e vai direto para a tela principal
  void _verificarLoginAutomatico() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioLogado = prefs.getBool(chaveUsuarioLogado) ?? false;
      final manterConectado = prefs.getBool(chaveManterConectado) ?? false;

      if (usuarioLogado && manterConectado) {
        // Aguarda um pouco para mostrar a tela de login
        await Future.delayed(const Duration(milliseconds: 800));

        // Navega direto para a tela principal
        if (mounted) {
          Navegacao.irParaTelaPrincipalAposLogin(context);
        }
      }
    } catch (e) {
      print('Erro ao verificar login automático: $e');
    }
  }

  // Salva as preferências do usuário
  Future<void> _salvarPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(chaveManterConectado, _manterConectado);

      if (_manterConectado && _emailController.text.isNotEmpty) {
        await prefs.setString(chaveEmail, _emailController.text);
        await prefs.setBool(chaveUsuarioLogado, true);
      } else if (!_manterConectado) {
        await prefs.remove(chaveEmail);
        await prefs.setBool(chaveUsuarioLogado, false);
      }
    } catch (e) {
      print('Erro ao salvar preferências: $e');
    }
  }

  void _login() async {
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final sucesso = await _authService.login(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (sucesso) {
        // Salva as preferências antes de navegar
        await _salvarPreferencias();

        _mostrarSucesso('Login realizado com sucesso!');
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navegacao.irParaTelaPrincipalAposLogin(context);
        }
      } else {
        _mostrarErro('Email ou senha incorretos');
      }
    } catch (e) {
      _mostrarErro('Erro ao fazer login: $e');
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _irParaCriarConta() {
    Navegacao.irParaCriarConta(context);
  }

  void _irParaEsqueceuSenha() {
    Navegacao.irParaEsqueceuSenha(context);
  }

  // Método para debug - verificar estado atual
  // ignore: unused_element
  void _verificarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    print('=== ESTADO ATUAL ===');
    print('Manter conectado: ${prefs.getBool(chaveManterConectado)}');
    print('Último email: ${prefs.getString(chaveEmail)}');
    print('Usuário logado: ${prefs.getBool(chaveUsuarioLogado)}');
    print('Usuário no AuthService: ${_authService.usuarioLogado?.email}');
    print('==================');
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
                      "Entrar",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Entre com sua conta para continuar",
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 80),

                    _campoTexto("E-mail", Icons.email, _emailController),
                    const SizedBox(height: 15),
                    _campoSenha("Senha", Icons.lock, _senhaController),
                    const SizedBox(height: 10),

                    // Checkbox "Manter conectado"
                    Row(
                      children: [
                        Checkbox(
                          value: _manterConectado,
                          onChanged: (value) {
                            setState(() {
                              _manterConectado = value ?? false;
                            });
                          },
                          checkColor: Colors.white,
                          fillColor: WidgetStateProperty.resolveWith<Color>((
                            Set<WidgetState> states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.cyan;
                            }
                            return Colors.white54;
                          }),
                        ),
                        const Text(
                          "Manter conectado",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: _irParaCriarConta,
                          child: const Text(
                            "Criar conta",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        TextButton(
                          onPressed: _irParaEsqueceuSenha,
                          child: const Text(
                            "Esqueceu a senha?",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _carregando
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                "Entrar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/cachorro2.png",
              height: 220,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(
    String label,
    IconData icone,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
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
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email é obrigatório';
        }
        if (!value.contains('@') || !value.contains('.')) {
          return 'Email inválido';
        }
        return null;
      },
    );
  }

  Widget _campoSenha(
    String label,
    IconData icone,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: !_senhaVisivel,
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
            _senhaVisivel ? Icons.visibility : Icons.visibility_off,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _senhaVisivel = !_senhaVisivel;
            });
          },
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Senha é obrigatória';
        }
        if (value.length < 6) {
          return 'Senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}

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
  bool _verificandoLoginAuto = true;

  @override
  void initState() {
    super.initState();
    _inicializarLogin();
  }

  // ✅ CORREÇÃO: Inicializa na ordem correta
  void _inicializarLogin() async {
    await _carregarPreferencias();
    await _verificarLoginAutomatico();
  }

  // ✅ CORREÇÃO: Carrega as preferências salvas
  Future<void> _carregarPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _manterConectado = prefs.getBool('manter_conectado') ?? false;
        final ultimoEmail = prefs.getString('ultimo_email');
        if (ultimoEmail != null) {
          _emailController.text = ultimoEmail;
        }
      });
      print('📝 Preferências carregadas:');
      print('   - Manter conectado: $_manterConectado');
      print('   - Email: ${_emailController.text}');
    } catch (e) {
      print('❌ Erro ao carregar preferências: $e');
    }
  }

  // ✅ CORREÇÃO: Método completamente refeito
  Future<void> _verificarLoginAutomatico() async {
    try {
      print('🔍 Verificando login automático...');

      final prefs = await SharedPreferences.getInstance();
      final manterConectado = prefs.getBool('manter_conectado') ?? false;
      final usuarioLogado = prefs.getBool('usuario_logado') ?? false;

      print('   - Manter conectado: $manterConectado');
      print('   - Usuário logado: $usuarioLogado');

      if (!manterConectado || !usuarioLogado) {
        print('❌ Login automático não está ativo');
        setState(() {
          _verificandoLoginAuto = false;
        });
        return;
      }

      // Aguarda um pouco para mostrar a tela de login
      await Future.delayed(const Duration(milliseconds: 1000));

      print('🔄 Tentando carregar usuário salvo...');
      final sucesso = await _authService.verificarLogin();

      if (sucesso && _authService.usuarioLogado != null) {
        print('✅ Login automático bem-sucedido!');
        print('👤 Usuário: ${_authService.usuarioLogado!.nome}');

        if (mounted) {
          Navegacao.irParaTelaPrincipalAposLogin(context);
        }
      } else {
        print('❌ Login automático falhou - usuário não encontrado');
        setState(() {
          _verificandoLoginAuto = false;
        });
      }
    } catch (e) {
      print('❌ Erro ao verificar login automático: $e');
      setState(() {
        _verificandoLoginAuto = false;
      });
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
      print('🔄 Tentando login manual...');
      final sucesso = await _authService.login(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (sucesso) {
        print('✅ Login manual bem-sucedido!');

        // ✅ CORREÇÃO: Salva as preferências localmente também
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('manter_conectado', _manterConectado);
        await prefs.setBool('usuario_logado', _manterConectado);

        if (_manterConectado) {
          await prefs.setString('ultimo_email', _emailController.text.trim());
        } else {
          await prefs.remove('ultimo_email');
        }

        print('💾 Preferências salvas:');
        print('   - Manter conectado: $_manterConectado');
        print('   - Email: ${_emailController.text.trim()}');

        _mostrarSucesso('Login realizado com sucesso!');
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navegacao.irParaTelaPrincipalAposLogin(context);
        }
      } else {
        _mostrarErro('Email ou senha incorretos');
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      _mostrarErro(mensagemErro);
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

                    // ✅ Mostra loading durante verificação automática
                    if (_verificandoLoginAuto) ...[
                      const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Verificando login...",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 80),
                        ],
                      ),
                    ],

                    _campoTexto("E-mail", Icons.email, _emailController),
                    const SizedBox(height: 15),
                    _campoSenha("Senha", Icons.lock, _senhaController),
                    const SizedBox(height: 10),

                    // ✅ CORREÇÃO: Checkbox "Manter conectado" funcional
                    if (!_verificandoLoginAuto)
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

                    if (!_verificandoLoginAuto) ...[
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
                    ],

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
    return Opacity(
      opacity: _verificandoLoginAuto ? 0.5 : 1.0,
      child: IgnorePointer(
        ignoring: _verificandoLoginAuto,
        child: TextFormField(
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
        ),
      ),
    );
  }

  Widget _campoSenha(
    String label,
    IconData icone,
    TextEditingController controller,
  ) {
    return Opacity(
      opacity: _verificandoLoginAuto ? 0.5 : 1.0,
      child: IgnorePointer(
        ignoring: _verificandoLoginAuto,
        child: TextFormField(
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }
}

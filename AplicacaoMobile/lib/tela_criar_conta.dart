import 'package:flutter/material.dart';
import 'fundo_patinha_aleatoria.dart';
import 'autenticacao.dart';
import 'navegacao.dart';

class TelaCriarConta extends StatefulWidget {
  const TelaCriarConta({super.key});

  @override
  State<TelaCriarConta> createState() => _TelaCriarContaState();
}

class _TelaCriarContaState extends State<TelaCriarConta> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final _authService = AuthService();
  bool _carregando = false;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;

  void _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_senhaController.text != _confirmarSenhaController.text) {
      _mostrarErro('As senhas não coincidem');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final novoUsuario = Usuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        senha: _senhaController.text,
      );

      final sucesso = await _authService.cadastrarUsuario(novoUsuario);

      if (sucesso) {
        _mostrarSucesso('Conta criada com sucesso!');

        // Login automático após cadastro
        final loginSucesso = await _authService.login(
          _emailController.text.trim(),
          _senhaController.text,
        );

        if (loginSucesso) {
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navegacao.irParaTelaPrincipalAposLogin(context);
          }
        } else {
          Navegacao.irParaLogin(context);
        }
      }
    } catch (e) {
      _mostrarErro(e.toString().replaceAll('Exception: ', ''));
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
      ),
    );
  }

  void _mostrarSucesso(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _voltarParaLogin() {
    Navegacao.voltar(context);
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
          // CONTEÚDO PRINCIPAL QUE OCUPA TODA A TELA
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Botão voltar
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: _voltarParaLogin,
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Text(
                          "Criar Conta",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Crie sua conta para começar a usar o ReconectaPet",
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        _campoTexto(
                          "Nome Completo",
                          Icons.person,
                          _nomeController,
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 12),
                        _campoTexto(
                          "E-mail",
                          Icons.email,
                          _emailController,
                          obrigatorio: true,
                          isEmail: true,
                        ),
                        const SizedBox(height: 12),
                        _campoTexto(
                          "Telefone",
                          Icons.phone,
                          _telefoneController,
                          obrigatorio: true,
                          isPhone: true,
                        ),
                        const SizedBox(height: 12),
                        _campoTexto(
                          "CPF",
                          Icons.credit_card,
                          _cpfController,
                          obrigatorio: true,
                          isCpf: true,
                        ),
                        const SizedBox(height: 12),
                        _campoSenha(
                          "Senha",
                          Icons.lock,
                          _senhaController,
                          obrigatorio: true,
                        ),
                        const SizedBox(height: 12),
                        _campoSenha(
                          "Confirmar Senha",
                          Icons.lock_outline,
                          _confirmarSenhaController,
                          obrigatorio: true,
                          isConfirmacao: true,
                        ),
                        const SizedBox(height: 25),

                        _carregando
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _cadastrar,
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
                                    "Criar Conta",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(height: 20),

                        // Link para voltar ao login
                        TextButton(
                          onPressed: _voltarParaLogin,
                          child: const Text(
                            "Já tem uma conta? Entrar",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        // ESPAÇO EXTRA PARA O CACHORRO NÃO COBRIR O CONTEÚDO
                        // Este espaço vai variar conforme a altura da tela
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // CACHORRO ENCOSTADO EM BAIXO (FORA DA ROLAGEM MAS DENTRO DA COLUNA)
              Container(
                height: 180, // Altura fixa para o cachorro
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  "assets/cachorroQueSofreAbuso.png",
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _campoTexto(
    String label,
    IconData icone,
    TextEditingController controller, {
    bool obrigatorio = false,
    bool isEmail = false,
    bool isPhone = false,
    bool isCpf = false,
  }) {
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
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
          ? TextInputType.phone
          : isCpf
          ? TextInputType.number
          : TextInputType.text,
      validator: (value) {
        if (obrigatorio && (value == null || value.isEmpty)) {
          return 'Este campo é obrigatório';
        }
        if (isEmail && value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
          if (!emailRegex.hasMatch(value)) {
            return 'Email inválido';
          }
        }
        if (isPhone && value != null && value.isNotEmpty) {
          final phoneRegex = RegExp(r'^[0-9]{10,11}$');
          final cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
          if (!phoneRegex.hasMatch(cleanPhone)) {
            return 'Telefone inválido (10 ou 11 dígitos)';
          }
        }
        if (isCpf && value != null && value.isNotEmpty) {
          final cleanCpf = value.replaceAll(RegExp(r'[^\d]'), '');
          if (cleanCpf.length != 11) {
            return 'CPF deve ter 11 dígitos';
          }
        }
        return null;
      },
    );
  }

  Widget _campoSenha(
    String label,
    IconData icone,
    TextEditingController controller, {
    bool obrigatorio = false,
    bool isConfirmacao = false,
  }) {
    return TextFormField(
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
      validator: (value) {
        if (obrigatorio && (value == null || value.isEmpty)) {
          return 'Este campo é obrigatório';
        }
        if (!isConfirmacao && value != null && value.length < 6) {
          return 'A senha deve ter pelo menos 6 caracteres';
        }
        if (isConfirmacao && value != _senhaController.text) {
          return 'As senhas não coincidem';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
}

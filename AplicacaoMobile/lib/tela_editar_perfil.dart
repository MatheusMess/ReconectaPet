import 'package:flutter/material.dart';
import 'autenticacao.dart';

class TelaEditarPerfil extends StatefulWidget {
  const TelaEditarPerfil({super.key});

  @override
  State<TelaEditarPerfil> createState() => _TelaEditarPerfilState();
}

class _TelaEditarPerfilState extends State<TelaEditarPerfil> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _authService = AuthService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  void _carregarDadosUsuario() {
    final usuario = _authService.usuarioLogado;
    if (usuario != null) {
      _nomeController.text = usuario.nome;
      _emailController.text = usuario.email;
      _telefoneController.text = usuario.telefone;
      _cpfController.text = usuario.cpf;
    }
  }

  void _salvarAlteracoes() async {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _cpfController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final usuarioAtualizado = Usuario(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        senha: _authService.usuarioLogado!.senha, // Mantém a senha atual
      );

      final sucesso = await _authService.atualizarPerfil(usuarioAtualizado);

      if (sucesso) {
        _mostrarSucesso('Perfil atualizado com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pop(context);
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        actions: [
          if (_carregando)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Foto de perfil
              GestureDetector(
                onTap: () {
                  _mostrarErro('Alteração de foto em desenvolvimento');
                },
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.cyan,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.cyan,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _campoTexto("Nome", Icons.person, _nomeController),
              const SizedBox(height: 15),
              _campoTexto(
                "Email",
                Icons.email,
                _emailController,
                isEmail: true,
              ),
              const SizedBox(height: 15),
              _campoTexto(
                "Telefone",
                Icons.phone,
                _telefoneController,
                isPhone: true,
              ),
              const SizedBox(height: 15),
              _campoTexto(
                "CPF",
                Icons.credit_card,
                _cpfController,
                isCpf: true,
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Salvar Alterações",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Cancelar",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
    String label,
    IconData icone,
    TextEditingController controller, {
    bool isEmail = false,
    bool isPhone = false,
    bool isCpf = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone, color: Colors.cyan),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
      ),
      keyboardType: isEmail
          ? TextInputType.emailAddress
          : isPhone
          ? TextInputType.phone
          : isCpf
          ? TextInputType.number
          : TextInputType.text,
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    super.dispose();
  }
}

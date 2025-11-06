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
  final AuthService _authService = AuthService();
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
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty) {
      _mostrarErro('Nome e email são obrigatórios');
      return;
    }

    final usuarioAtual = _authService.usuarioLogado;
    if (usuarioAtual == null) {
      _mostrarErro('Usuário não encontrado');
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // Criar usuário atualizado mantendo o ID e senha
      final usuarioAtualizado = Usuario(
        id: usuarioAtual.id,
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        cpf: _cpfController.text.trim(),
        senha: usuarioAtual.senha, // Mantém a senha atual
        dataCriacao: usuarioAtual.dataCriacao, // Mantém a data de criação
      );

      final sucesso = await _authService.atualizarPerfil(usuarioAtualizado);

      if (sucesso) {
        _mostrarSucesso('Perfil atualizado com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        _mostrarErro('Erro ao atualizar perfil');
      }
    } catch (e) {
      _mostrarErro('Erro: ${e.toString().replaceAll('Exception: ', '')}');
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarMensagem(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 2)),
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
                  _mostrarMensagem('Alteração de foto em desenvolvimento');
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
                          color: Colors.cyan[700],
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

              // Campos do formulário
              _campoTexto(
                "Nome *",
                Icons.person,
                _nomeController,
                hintText: "Digite seu nome completo",
              ),
              const SizedBox(height: 16),

              _campoTexto(
                "Email *",
                Icons.email,
                _emailController,
                hintText: "Digite seu email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _campoTexto(
                "Telefone *",
                Icons.phone,
                _telefoneController,
                hintText: "(11) 99999-9999",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _campoTexto(
                "CPF *",
                Icons.credit_card,
                _cpfController,
                hintText: "000.000.000-00",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 40),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _salvarAlteracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          "SALVAR ALTERAÇÕES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Botão Cancelar
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _carregando ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "CANCELAR",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Informação sobre campos obrigatórios
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.cyan[700], size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Todos os campos são obrigatórios",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Informação sobre dados do usuário
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue[700], size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Seus dados estão seguros e armazenados localmente",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 25, 118, 210),
                        ),
                      ),
                    ),
                  ],
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
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icone, color: Colors.cyan),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyan, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      keyboardType: keyboardType,
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

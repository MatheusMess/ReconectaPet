import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;
  final DateTime dataCriacao;

  Usuario({
    String? id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
    DateTime? dataCriacao,
  }) : id = id ?? _gerarId(),
       dataCriacao = dataCriacao ?? DateTime.now();

  // Gerar ID único
  static String _gerarId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${timestamp}_${random.nextInt(10000)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'cpf': cpf,
      'senha': senha,
      'dataCriacao': dataCriacao.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? _gerarId(),
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      cpf: map['cpf'] ?? '',
      senha: map['senha'] ?? '',
      dataCriacao: map['dataCriacao'] != null
          ? DateTime.parse(map['dataCriacao'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));

  // Cópia do usuário com campos atualizados
  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? cpf,
    String? senha,
    DateTime? dataCriacao,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      senha: senha ?? this.senha,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Usuario && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _arquivoUsuarios = 'usuarios.txt';
  Usuario? _usuarioLogado;

  // Mapa para armazenar códigos de recuperação
  final Map<String, String> _codigosRecuperacao = {};
  final Map<String, DateTime> _codigosExpiracao = {};

  Usuario? get usuarioLogado => _usuarioLogado;

  Future<File> _getArquivo() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File('${directory.path}/$_arquivoUsuarios');
    } catch (e) {
      final directory = await getTemporaryDirectory();
      return File('${directory.path}/$_arquivoUsuarios');
    }
  }

  // Gerar código de recuperação
  String _gerarCodigoRecuperacao() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6 dígitos
  }

  // Solicitar recuperação de senha
  Future<bool> solicitarRecuperacaoSenha(String email) async {
    try {
      final usuarios = await _carregarUsuarios();
      final usuario = usuarios.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () =>
            Usuario(nome: '', email: '', telefone: '', cpf: '', senha: ''),
      );

      if (usuario.email.isEmpty) {
        throw Exception('Email não cadastrado');
      }

      // Gerar código
      final codigo = _gerarCodigoRecuperacao();
      _codigosRecuperacao[email] = codigo;
      _codigosExpiracao[email] = DateTime.now().add(
        const Duration(minutes: 15),
      );

      // Em produção, aqui você enviaria o email
      print('🔐 Código de recuperação para $email: $codigo');

      return true;
    } catch (e) {
      print('Erro ao solicitar recuperação: $e');
      throw Exception('Erro ao solicitar recuperação de senha');
    }
  }

  // Verificar código de recuperação
  bool verificarCodigoRecuperacao(String email, String codigo) {
    final codigoArmazenado = _codigosRecuperacao[email];
    final expiracao = _codigosExpiracao[email];

    if (codigoArmazenado == null || expiracao == null) {
      return false;
    }

    if (DateTime.now().isAfter(expiracao)) {
      _codigosRecuperacao.remove(email);
      _codigosExpiracao.remove(email);
      return false;
    }

    return codigoArmazenado == codigo;
  }

  // Redefinir senha
  Future<bool> redefinirSenha(String email, String novaSenha) async {
    try {
      final arquivo = await _getArquivo();
      final usuarios = await _carregarUsuarios();

      final index = usuarios.indexWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
      );

      if (index == -1) {
        throw Exception('Usuário não encontrado');
      }

      // Atualizar senha mantendo o ID
      final usuario = usuarios[index];
      usuarios[index] = usuario.copyWith(senha: novaSenha);

      // Salvar alterações
      final linhas = usuarios.map((usuario) => usuario.toJson()).toList();
      await arquivo.writeAsString(linhas.join('\n'));

      // Limpar código de recuperação
      _codigosRecuperacao.remove(email);
      _codigosExpiracao.remove(email);

      print('Senha redefinida com sucesso para: $email');
      return true;
    } catch (e) {
      print('Erro ao redefinir senha: $e');
      throw Exception('Erro ao redefinir senha');
    }
  }

  // Atualizar perfil do usuário
  Future<bool> atualizarPerfil(Usuario usuarioAtualizado) async {
    try {
      final arquivo = await _getArquivo();
      final usuarios = await _carregarUsuarios();

      final index = usuarios.indexWhere(
        (user) => user.id == usuarioAtualizado.id, // Agora usa ID
      );

      if (index == -1) {
        throw Exception('Usuário não encontrado');
      }

      // Atualizar dados do usuário mantendo o ID
      usuarios[index] = usuarioAtualizado;

      // Salvar alterações
      final linhas = usuarios.map((usuario) => usuario.toJson()).toList();
      await arquivo.writeAsString(linhas.join('\n'));

      // Atualizar usuário logado
      _usuarioLogado = usuarioAtualizado;

      print('Perfil atualizado com sucesso: ${usuarioAtualizado.email}');
      return true;
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      throw Exception('Erro ao atualizar perfil');
    }
  }

  Future<bool> cadastrarUsuario(Usuario novoUsuario) async {
    try {
      if (novoUsuario.email.isEmpty) {
        throw Exception('Email é obrigatório');
      }

      final arquivo = await _getArquivo();
      final usuarios = await _carregarUsuarios();

      if (usuarios.any(
        (usuario) =>
            usuario.email.toLowerCase() == novoUsuario.email.toLowerCase(),
      )) {
        throw Exception('Email já cadastrado');
      }

      if (usuarios.any((usuario) => usuario.cpf == novoUsuario.cpf)) {
        throw Exception('CPF já cadastrado');
      }

      // Garantir que o usuário tenha um ID
      final usuarioComId = novoUsuario.id.isEmpty
          ? Usuario(
              nome: novoUsuario.nome,
              email: novoUsuario.email,
              telefone: novoUsuario.telefone,
              cpf: novoUsuario.cpf,
              senha: novoUsuario.senha,
            )
          : novoUsuario;

      usuarios.add(usuarioComId);

      final linhas = usuarios.map((usuario) => usuario.toJson()).toList();
      await arquivo.writeAsString(linhas.join('\n'));

      print(
        'Usuário ${usuarioComId.email} (ID: ${usuarioComId.id}) cadastrado com sucesso!',
      );
      return true;
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      throw Exception('Erro ao cadastrar usuário: ${e.toString()}');
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      if (email.isEmpty || senha.isEmpty) {
        throw Exception('Email e senha são obrigatórios');
      }

      final usuarios = await _carregarUsuarios();
      final usuario = usuarios.firstWhere(
        (user) =>
            user.email.toLowerCase() == email.toLowerCase() &&
            user.senha == senha,
        orElse: () =>
            Usuario(nome: '', email: '', telefone: '', cpf: '', senha: ''),
      );

      if (usuario.email.isNotEmpty) {
        _usuarioLogado = usuario;
        print('Usuário $email (ID: ${usuario.id}) logado com sucesso!');
        return true;
      }
      print('Login falhou para: $email');
      return false;
    } catch (e) {
      print('Erro ao fazer login: $e');
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }

  Future<List<Usuario>> _carregarUsuarios() async {
    try {
      final arquivo = await _getArquivo();

      if (!await arquivo.exists()) {
        print('Arquivo de usuários não existe, criando novo...');
        return [];
      }

      final conteudo = await arquivo.readAsString();
      if (conteudo.isEmpty) {
        print('Arquivo de usuários está vazio');
        return [];
      }

      final linhas = conteudo.split('\n');
      final usuarios = linhas
          .where((linha) => linha.trim().isNotEmpty)
          .map((linha) {
            try {
              return Usuario.fromJson(linha);
            } catch (e) {
              print('Erro ao parsear linha: $linha - $e');
              return null;
            }
          })
          .where((usuario) => usuario != null)
          .cast<Usuario>()
          .toList();

      print('Carregados ${usuarios.length} usuários');
      return usuarios;
    } catch (e) {
      print('Erro ao carregar usuários: $e');
      return [];
    }
  }

  void logout() {
    _usuarioLogado = null;
    print('Usuário deslogado');
  }

  // Dentro da classe AuthService, adicione:
  static Future<void> limparLoginSalvo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('usuario_logado', false);
      await prefs.setBool('manter_conectado', false);
      await prefs.remove('ultimo_email');
      print('✅ Login salvo foi limpo pelo AuthService');
    } catch (e) {
      print('❌ Erro ao limpar login: $e');
    }
  }

  Future<bool> usuarioExiste(String email) async {
    final usuarios = await _carregarUsuarios();
    return usuarios.any(
      (usuario) => usuario.email.toLowerCase() == email.toLowerCase(),
    );
  }

  // Buscar usuário por ID
  Future<Usuario?> buscarUsuarioPorId(String id) async {
    final usuarios = await _carregarUsuarios();
    try {
      return usuarios.firstWhere((usuario) => usuario.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> debugListarUsuarios() async {
    final usuarios = await _carregarUsuarios();
    print('=== USUÁRIOS CADASTRADOS (${usuarios.length}) ===');
    for (var usuario in usuarios) {
      print(
        'ID: ${usuario.id} | Nome: ${usuario.nome} | Email: ${usuario.email} | Criado: ${usuario.dataCriacao}',
      );
    }
    print('================================');
  }
}

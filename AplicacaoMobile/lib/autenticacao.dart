import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String? senha;
  final DateTime? dataCriacao;
  final String? apiToken;

  Usuario({
    String? id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    this.senha,
    this.dataCriacao,
    this.apiToken,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'tel': telefone,
      'cpf': cpf,
      'password': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id']?.toString() ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['tel'] ?? '',
      cpf: map['cpf'] ?? '',
      apiToken: map['token'],
      dataCriacao: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? cpf,
    String? senha,
    String? apiToken,
    DateTime? dataCriacao,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      senha: senha ?? this.senha,
      apiToken: apiToken ?? this.apiToken,
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

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, telefone: $telefone)';
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _storageKey = 'usuario_logado';
  // ⚠️ ATUALIZE PARA SEU IP:
  static const String _baseUrl = 'http://192.168.15.16:8000';
  Usuario? _usuarioLogado;

  final Map<String, String> _codigosRecuperacao = {};
  final Map<String, DateTime> _codigosExpiracao = {};

  Usuario? get usuarioLogado => _usuarioLogado;
  String? get token => _usuarioLogado?.apiToken;

  // ========== MÉTODOS PRINCIPAIS ==========

  Future<bool> testarConexaoAPI() async {
    try {
      print('🔍 TESTANDO CONEXÃO COM A API...');
      final response = await http.get(
        Uri.parse('$_baseUrl/api/animais'),
        headers: _headers,
      );

      print('📡 Status da conexão: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ ERRO NA CONEXÃO: $e');
      return false;
    }
  }

  Future<bool> cadastrarUsuario(Usuario novoUsuario) async {
    try {
      print('🔄 === INICIANDO CADASTRO ===');
      print('📧 Email: ${novoUsuario.email}');
      print('🌐 URL: $_baseUrl/api/register');

      // Testar conexão primeiro
      final conexaoOk = await testarConexaoAPI();
      if (!conexaoOk) {
        throw Exception(
          'Não foi possível conectar com a API. Verifique o IP e se o servidor está rodando.',
        );
      }

      print('📤 Enviando dados para cadastro...');
      final response = await http.post(
        Uri.parse('$_baseUrl/api/register'),
        headers: _headers,
        body: json.encode(novoUsuario.toMap()),
      );

      print('📡 STATUS CODE: ${response.statusCode}');
      print('📦 RESPOSTA BRUTA: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('🔍 RESPOSTA DECODIFICADA: $data');

        if (data['success'] == true) {
          final userData = data['user'];

          print('✅ Cadastro bem-sucedido!');
          print('👤 User data: $userData');

          final usuario = Usuario.fromMap(userData);
          await _salvarUsuarioLogado(usuario);
          return true;
        } else {
          throw Exception(data['message'] ?? 'Erro no cadastro');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ??
            errorData['errors']?.toString() ??
            'Erro HTTP ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ ERRO NO CADASTRO: $e');
      print('🔄 Tentando cadastro local...');
      return await _cadastrarUsuarioLocal(novoUsuario);
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      print('🔄 === INICIANDO LOGIN ===');
      print('📧 Email: $email');
      print('🌐 URL: $_baseUrl/api/login');

      // Testar conexão primeiro
      final conexaoOk = await testarConexaoAPI();
      if (!conexaoOk) {
        throw Exception(
          'Não foi possível conectar com a API. Verifique o IP e se o servidor está rodando.',
        );
      }

      print('📤 Enviando dados para login...');
      print(
        '🔍 Dados enviados: ${json.encode({'email': email, 'password': senha})}',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/api/login'),
        headers: _headers,
        body: json.encode({'email': email, 'password': senha}),
      );

      print('📡 STATUS CODE: ${response.statusCode}');
      print('📦 RESPOSTA BRUTA: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('🔍 RESPOSTA DECODIFICADA: $data');

        if (data['success'] == true) {
          final userData = data['user'];

          print('✅ Login bem-sucedido!');
          print('👤 User data: $userData');

          final usuario = Usuario.fromMap(userData);
          await _salvarUsuarioLogado(usuario);
          return true;
        } else {
          throw Exception(data['message'] ?? 'Login falhou');
        }
      } else {
        final errorData = json.decode(response.body);
        final errorMessage =
            errorData['message'] ?? 'Erro HTTP ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('❌ ERRO NO LOGIN: $e');
      print('🔄 Tentando login local...');
      return await _loginLocal(email, senha);
    }
  }

  Future<void> logout() async {
    try {
      print('🔄 Fazendo logout...');
      await http.post(Uri.parse('$_baseUrl/api/logout'), headers: _headers);
      print('✅ Logout realizado');
    } catch (e) {
      print('❌ Erro no logout: $e');
    } finally {
      _usuarioLogado = null;
      await _limparUsuarioSalvo();
      print('✅ Usuário deslogado localmente');
    }
  }

  Future<bool> verificarLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString(_storageKey);

      if (usuarioJson != null) {
        final usuario = Usuario.fromJson(usuarioJson);
        print('🔍 Verificando usuário salvo: ${usuario.email}');

        _usuarioLogado = usuario;
        print('✅ Usuário logado: ${usuario.email}');
        return true;
      }

      print('🔍 Nenhum usuário logado encontrado');
      return false;
    } catch (e) {
      print('❌ Erro ao verificar login: $e');
      final prefs = await SharedPreferences.getInstance();
      final hasUser = prefs.containsKey(_storageKey);
      print('🔍 Fallback local - usuário salvo: $hasUser');
      return hasUser;
    }
  }

  // ========== RECUPERAÇÃO DE SENHA ==========

  Future<bool> solicitarRecuperacaoSenha(String email) async {
    try {
      print('🔄 Solicitando recuperação de senha...');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/forgot-password'),
        headers: _headers,
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('✅ Link de recuperação enviado para: $email');
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao solicitar recuperação');
      }
    } catch (e) {
      print('❌ Erro ao solicitar recuperação: $e');
      return await _solicitarRecuperacaoLocal(email);
    }
  }

  Future<bool> redefinirSenha(String email, String novaSenha) async {
    try {
      print('🔄 Redefinindo senha...');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/reset-password'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': novaSenha,
          'password_confirmation': novaSenha,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Senha redefinida com sucesso para: $email');
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao redefinir senha');
      }
    } catch (e) {
      print('❌ Erro ao redefinir senha: $e');
      return await _redefinirSenhaLocal(email, novaSenha);
    }
  }

  // ========== ATUALIZAÇÃO DE PERFIL ==========

  Future<bool> atualizarPerfil(Usuario usuarioAtualizado) async {
    try {
      print('🔄 Atualizando perfil...');

      final response = await http.put(
        Uri.parse('$_baseUrl/api/user/profile'),
        headers: _headers,
        body: json.encode(usuarioAtualizado.toMap()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final usuario = Usuario.fromMap(data['user'] ?? data);

        await _salvarUsuarioLogado(usuario);

        print('✅ Perfil atualizado com sucesso');
        return true;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao atualizar perfil');
      }
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      return await _atualizarPerfilLocal(usuarioAtualizado);
    }
  }

  // ========== MÉTODOS AUXILIARES ==========

  Map<String, String> get _headers {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Future<void> _salvarUsuarioLogado(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, usuario.toJson());
    _usuarioLogado = usuario;
    print('💾 Usuário salvo localmente: ${usuario.email}');
  }

  Future<void> _limparUsuarioSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await prefs.setBool('usuario_logado', false);
    await prefs.setBool('manter_conectado', false);
    await prefs.remove('ultimo_email');
    print('🗑️  Dados do usuário removidos localmente');
  }

  // ========== FALLBACKS LOCAIS ==========

  Future<bool> _cadastrarUsuarioLocal(Usuario novoUsuario) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];

      // Verificar se email já existe
      for (var usuarioJson in usuariosJson) {
        final usuario = Usuario.fromJson(usuarioJson);
        if (usuario.email.toLowerCase() == novoUsuario.email.toLowerCase()) {
          throw Exception('Email já cadastrado');
        }
      }

      // Adicionar novo usuário
      usuariosJson.add(novoUsuario.toJson());
      await prefs.setStringList('usuarios_locais', usuariosJson);
      await _salvarUsuarioLogado(novoUsuario);

      print('✅ Usuário cadastrado localmente: ${novoUsuario.email}');
      return true;
    } catch (e) {
      print('❌ Erro no cadastro local: $e');
      rethrow;
    }
  }

  Future<bool> _loginLocal(String email, String senha) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];

      for (var usuarioJson in usuariosJson) {
        final usuario = Usuario.fromJson(usuarioJson);
        if (usuario.email.toLowerCase() == email.toLowerCase() &&
            usuario.senha == senha) {
          await _salvarUsuarioLogado(usuario);
          print('✅ Login local realizado: $email');
          return true;
        }
      }

      throw Exception('Credenciais inválidas');
    } catch (e) {
      print('❌ Erro no login local: $e');
      rethrow;
    }
  }

  Future<bool> _solicitarRecuperacaoLocal(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];

    for (var usuarioJson in usuariosJson) {
      final usuario = Usuario.fromJson(usuarioJson);
      if (usuario.email.toLowerCase() == email.toLowerCase()) {
        final codigo = _gerarCodigoRecuperacao();
        _codigosRecuperacao[email] = codigo;
        _codigosExpiracao[email] = DateTime.now().add(
          const Duration(minutes: 15),
        );

        print('🔐 Código de recuperação para $email: $codigo');
        return true;
      }
    }

    throw Exception('Email não cadastrado');
  }

  Future<bool> _redefinirSenhaLocal(String email, String novaSenha) async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];

    for (int i = 0; i < usuariosJson.length; i++) {
      final usuario = Usuario.fromJson(usuariosJson[i]);
      if (usuario.email.toLowerCase() == email.toLowerCase()) {
        final usuarioAtualizado = usuario.copyWith(senha: novaSenha);
        usuariosJson[i] = usuarioAtualizado.toJson();

        await prefs.setStringList('usuarios_locais', usuariosJson);

        if (_usuarioLogado?.email == email) {
          await _salvarUsuarioLogado(usuarioAtualizado);
        }

        print('✅ Senha redefinida localmente para: $email');
        return true;
      }
    }

    throw Exception('Email não encontrado');
  }

  Future<bool> _atualizarPerfilLocal(Usuario usuarioAtualizado) async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];

    for (int i = 0; i < usuariosJson.length; i++) {
      final usuario = Usuario.fromJson(usuariosJson[i]);
      if (usuario.id == usuarioAtualizado.id) {
        usuariosJson[i] = usuarioAtualizado.toJson();
        await prefs.setStringList('usuarios_locais', usuariosJson);
        await _salvarUsuarioLogado(usuarioAtualizado);

        print('✅ Perfil atualizado localmente: ${usuarioAtualizado.email}');
        return true;
      }
    }

    throw Exception('Usuário não encontrado');
  }

  String _gerarCodigoRecuperacao() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

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

  // ========== UTILITÁRIOS ==========

  Future<bool> usuarioExiste(String email) async {
    try {
      print('🔍 Verificando se email existe: $email');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/check-email'),
        headers: _headers,
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exists = data['exists'] ?? false;
        print('📧 Email $email existe: $exists');
        return exists;
      }
    } catch (e) {
      print('❌ Erro ao verificar email: $e');
    }

    // Fallback local
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];
    final exists = usuariosJson.any((usuarioJson) {
      final usuario = Usuario.fromJson(usuarioJson);
      return usuario.email.toLowerCase() == email.toLowerCase();
    });

    print('📧 Email $email existe (local): $exists');
    return exists;
  }

  Future<Usuario?> buscarUsuarioPorId(String id) async {
    if (_usuarioLogado?.id == id) return _usuarioLogado;

    // Fallback local
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];
    try {
      return usuariosJson
          .map((json) => Usuario.fromJson(json))
          .firstWhere((usuario) => usuario.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> limparLoginSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('usuario_logado', false);
    await prefs.setBool('manter_conectado', false);
    await prefs.remove('ultimo_email');
    await prefs.remove('usuarios_locais');
    print('✅ Login salvo foi limpo');
  }

  // Método para debug do usuário atual
  void debugUsuarioAtual() {
    if (_usuarioLogado != null) {
      print('=== USUÁRIO ATUAL ===');
      print('ID: ${_usuarioLogado!.id}');
      print('Nome: ${_usuarioLogado!.nome}');
      print('Email: ${_usuarioLogado!.email}');
      print('Telefone: ${_usuarioLogado!.telefone}');
      print('==================');
    } else {
      print('=== NENHUM USUÁRIO LOGADO ===');
    }
  }

  // Método para debug dos usuários locais
  Future<void> debugUsuariosLocais() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosJson = prefs.getStringList('usuarios_locais') ?? [];
    print('=== USUÁRIOS LOCAIS (${usuariosJson.length}) ===');
    for (var usuarioJson in usuariosJson) {
      final usuario = Usuario.fromJson(usuarioJson);
      print(
        'ID: ${usuario.id} | Nome: ${usuario.nome} | Email: ${usuario.email} | Senha: ${usuario.senha != null ? "***" : "null"}',
      );
    }
    print('================================');
  }

  // Método para testar conexão completa
  Future<void> testarConexaoCompleto() async {
    print('🎯 === TESTE COMPLETO DE CONEXÃO ===');

    // Teste 1: Conexão básica
    try {
      final url = Uri.parse('$_baseUrl');
      print('1. 🔌 Testando conexão básica: $url');

      final response = await http.get(url).timeout(Duration(seconds: 5));
      print('   ✅ Resposta: ${response.statusCode}');
    } catch (e) {
      print('   ❌ Erro: $e');
    }

    // Teste 2: API endpoint
    try {
      final url = Uri.parse('$_baseUrl/api/animais');
      print('2. 🔌 Testando API: $url');

      final response = await http.get(url).timeout(Duration(seconds: 5));
      print('   ✅ Resposta: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('   📦 Conteúdo: ${response.body.length} caracteres');
      }
    } catch (e) {
      print('   ❌ Erro: $e');
    }

    print('🎯 === FIM DO TESTE ===');
  }
}

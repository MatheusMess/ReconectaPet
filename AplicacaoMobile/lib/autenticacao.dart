import 'dart:convert';
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
  final bool adm;
  final bool banido;

  Usuario({
    String? id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    this.senha,
    this.dataCriacao,
    this.apiToken,
    this.adm = false,
    this.banido = false,
  }) : id = id ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tel': telefone,
      'cpf': cpf,
      'password': senha,
      'token': apiToken,
      'adm': adm,
      'banido': banido,
      'created_at': dataCriacao?.toIso8601String(),
    };
  }

  Map<String, dynamic> toMapParaAtualizacao() {
    return {'user_id': id, 'nome': nome, 'tel': telefone};
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    print('🔄 Convertendo Map para Usuario:');
    print('   - Map recebido: $map');

    // ✅ CORREÇÃO: Conversão segura dos campos
    String safeString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is num) return value.toString();
      if (value is bool) return value.toString();
      return value.toString();
    }

    bool safeBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is num) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    String? safeStringOrNull(dynamic value) {
      if (value == null) return null;
      if (value is String) return value.isEmpty ? null : value;
      if (value is num) return value.toString();
      return value.toString();
    }

    DateTime? safeDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          print('❌ Erro ao parsear data: $value');
          return null;
        }
      }
      return null;
    }

    final usuario = Usuario(
      id: safeString(map['id']),
      nome: safeString(map['nome']),
      email: safeString(map['email']),
      telefone: safeString(map['tel'] ?? map['telefone']),
      cpf: safeString(map['cpf']),
      senha: safeStringOrNull(map['password'] ?? map['senha']),
      apiToken: safeStringOrNull(map['token'] ?? map['apiToken']),
      adm: safeBool(map['adm']),
      banido: safeBool(map['banido']),
      dataCriacao: safeDateTime(map['created_at'] ?? map['dataCriacao']),
    );

    print('✅ Usuario convertido: ${usuario.toString()}');
    return usuario;
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) {
    try {
      final Map<String, dynamic> map = json.decode(source);
      return Usuario.fromMap(map);
    } catch (e) {
      print('❌ Erro ao decodificar JSON: $e');
      print('❌ JSON problemático: $source');
      rethrow;
    }
  }

  Usuario copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? cpf,
    String? senha,
    String? apiToken,
    DateTime? dataCriacao,
    bool? adm,
    bool? banido,
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
      adm: adm ?? this.adm,
      banido: banido ?? this.banido,
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, telefone: $telefone, banido: $banido)';
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _storageKey = 'usuario_logado';
  static const String _baseUrl = 'http://192.168.15.16:8000';
  Usuario? _usuarioLogado;

  Usuario? get usuarioLogado => _usuarioLogado;
  String? get token => _usuarioLogado?.apiToken;
  bool get usuarioEstaBanido => _usuarioLogado?.banido == true;

  // ========== MÉTODOS PRINCIPAIS ==========

  Future<bool> cadastrarUsuario(Usuario novoUsuario) async {
    try {
      print('🔄 === INICIANDO CADASTRO ===');
      print('📧 Email: ${novoUsuario.email}');
      print('📦 Dados: ${novoUsuario.toMap()}');

      final usuarioParaCadastro = novoUsuario.copyWith(banido: false);

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/register'),
            headers: _headers,
            body: json.encode(usuarioParaCadastro.toMap()),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final usuario = Usuario.fromMap(data['user']);

          if (usuario.banido) {
            throw Exception(
              'Erro: Usuário foi criado como banido. Contate o suporte.',
            );
          }

          await _salvarUsuarioLogado(usuario);
          print('✅ Cadastro bem-sucedido!');
          return true;
        } else {
          throw Exception(data['message'] ?? 'Erro no cadastro');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO NO CADASTRO: $mensagemErro');
      rethrow;
    }
  }

  Future<bool> login(String email, String senha) async {
    try {
      print('🔄 === INICIANDO LOGIN ===');
      print('📧 Email: $email');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/login'),
            headers: _headers,
            body: json.encode({'email': email, 'password': senha}),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final usuario = Usuario.fromMap(data['user']);

          if (usuario.banido) {
            await _limparUsuarioSalvo();
            throw Exception(
              '🚫 ACESSO BLOQUEADO\n\nSua conta foi banida do sistema. Entre em contato com o suporte para mais informações.',
            );
          }

          await _salvarUsuarioLogado(usuario);
          print('✅ Login bem-sucedido!');
          print('👤 Status do usuário: ${usuario.banido ? "BANIDO" : "ATIVO"}');
          return true;
        } else {
          throw Exception(data['message'] ?? 'Login falhou');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO NO LOGIN: $mensagemErro');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await http
          .post(Uri.parse('$_baseUrl/api/logout'), headers: _headers)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ Erro no logout: $mensagemErro');
    } finally {
      _usuarioLogado = null;
      await _limparUsuarioSalvo();
      await _limparManterConectado();
    }
  }

  // ✅ MÉTODO VERIFICARLOGIN CORRIGIDO - VERSÃO SIMPLIFICADA
  Future<bool> verificarLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString(_storageKey);

      print('🔍 Verificando login salvo...');
      print('   - Chave: $_storageKey');
      print('   - Usuário JSON existe: ${usuarioJson != null}');

      if (usuarioJson == null || usuarioJson.isEmpty) {
        print('❌ Nenhum usuário salvo encontrado');
        return false;
      }

      try {
        // ✅ CORREÇÃO: Parse seguro do JSON
        final Map<String, dynamic> usuarioMap = json.decode(usuarioJson);
        print('   - JSON decodificado com sucesso');
        print('   - Keys do map: ${usuarioMap.keys}');

        // ✅ CORREÇÃO: Usa o mesmo método fromMap que já funciona
        final usuario = Usuario.fromMap(usuarioMap);

        // ✅ Verificação básica dos campos obrigatórios
        if (usuario.id.isEmpty || usuario.email.isEmpty) {
          print('⚠️ Usuário inválido - campos obrigatórios faltando');
          print('   - ID: "${usuario.id}"');
          print('   - Email: "${usuario.email}"');
          await _limparUsuarioSalvo();
          return false;
        }

        if (usuario.banido) {
          print('⚠️ Usuário banido detectado no login salvo');
          await _limparUsuarioSalvo();
          return false;
        }

        _usuarioLogado = usuario;
        print('✅ Usuário carregado com sucesso: ${usuario.nome}');
        print('   - ID: ${usuario.id}');
        print('   - Email: ${usuario.email}');
        print('   - Banido: ${usuario.banido}');
        return true;
      } catch (e) {
        print('❌ Erro ao decodificar usuário: $e');
        print('❌ JSON problemático: $usuarioJson');
        await _limparUsuarioSalvo();
        return false;
      }
    } catch (e) {
      print('❌ Erro ao verificar login: $e');
      return false;
    }
  }

  // ✅ MÉTODO DE DEBUG: Verificar o que está salvo
  Future<void> debugPreferencias() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      print('=== DEBUG PREFERÊNCIAS ===');
      print('manter_conectado: ${prefs.getBool('manter_conectado')}');
      print('usuario_logado: ${prefs.getBool('usuario_logado')}');
      print('ultimo_email: ${prefs.getString('ultimo_email')}');

      final usuarioJson = prefs.getString(_storageKey);
      print('usuario_json: $usuarioJson');

      if (usuarioJson != null) {
        try {
          final parsed = json.decode(usuarioJson);
          print('usuario_parsed: $parsed');
        } catch (e) {
          print('❌ Erro ao parsear usuario_json: $e');
        }
      }
      print('==========================');
    } catch (e) {
      print('❌ Erro no debug: $e');
    }
  }

  // ✅ MÉTODO PARA LIMPAR DADOS CORROMPIDOS
  Future<void> limparDadosCorrompidos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      await prefs.setBool('manter_conectado', false);
      await prefs.setBool('usuario_logado', false);
      await prefs.remove('ultimo_email');
      _usuarioLogado = null;
      print('🗑️ Dados corrompidos limpos com sucesso');
    } catch (e) {
      print('❌ Erro ao limpar dados corrompidos: $e');
    }
  }

  // ✅ NOVO MÉTODO: Verificar login automático com "manter conectado"
  Future<bool> verificarLoginAutomatico() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final manterConectado = prefs.getBool('manter_conectado') ?? false;
      final usuarioLogado = prefs.getBool('usuario_logado') ?? false;

      print('🔍 Verificando login automático:');
      print('   - Manter conectado: $manterConectado');
      print('   - Usuário logado: $usuarioLogado');

      if (manterConectado && usuarioLogado) {
        final sucesso = await verificarLogin();
        print('   - Usuário carregado: $sucesso');
        return sucesso;
      }

      return false;
    } catch (e) {
      print('❌ Erro ao verificar login automático: $e');
      return false;
    }
  }

  // ✅ NOVO MÉTODO: Salvar preferências de "manter conectado"
  Future<void> salvarPreferenciasLogin({
    required bool manterConectado,
    required String email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('manter_conectado', manterConectado);
      await prefs.setBool('usuario_logado', manterConectado);

      if (manterConectado) {
        await prefs.setString('ultimo_email', email);
      } else {
        await prefs.remove('ultimo_email');
      }

      print('💾 Preferências salvas:');
      print('   - Manter conectado: $manterConectado');
      print('   - Email: $email');
    } catch (e) {
      print('❌ Erro ao salvar preferências: $e');
    }
  }

  // ✅ NOVO MÉTODO: Limpar "manter conectado"
  Future<void> _limparManterConectado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('manter_conectado', false);
      await prefs.setBool('usuario_logado', false);
      await prefs.remove('ultimo_email');
      print('🗑️ Preferências de login limpas');
    } catch (e) {
      print('❌ Erro ao limpar preferências: $e');
    }
  }

  // ========== RECUPERAÇÃO DE SENHA ==========

  Future<bool> solicitarRecuperacaoSenha(String email) async {
    try {
      print('🔄 === SOLICITANDO RECUPERAÇÃO DE SENHA ===');
      print('📧 Email: $email');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/esqueceu_senha'),
            headers: _headers,
            body: json.encode({'email': email}),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('✅ Solicitação de recuperação enviada com sucesso');
          return true;
        } else {
          throw Exception(data['message'] ?? 'Erro ao solicitar recuperação');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO NA RECUPERAÇÃO DE SENHA: $mensagemErro');
      rethrow;
    }
  }

  Future<bool> verificarCodigoRecuperacao(String email, String codigo) async {
    try {
      print('🔄 === VERIFICANDO CÓDIGO DE RECUPERAÇÃO ===');
      print('📧 Email: $email');
      print('🔢 Código: $codigo');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/verificar_codigo'),
            headers: _headers,
            body: json.encode({'email': email, 'codigo': codigo}),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('✅ Código verificado com sucesso');
          return true;
        } else {
          if (data['message'] != null) {
            throw Exception(data['message']);
          } else {
            throw Exception('Código inválido ou expirado');
          }
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO NA VERIFICAÇÃO DO CÓDIGO: $mensagemErro');
      rethrow;
    }
  }

  Future<bool> redefinirSenha(String email, String novaSenha) async {
    try {
      print('🔄 === REDEFININDO SENHA ===');
      print('📧 Email: $email');

      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/redefinir_senha'),
            headers: _headers,
            body: json.encode({'email': email, 'password': novaSenha}),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          print('✅ Senha redefinida com sucesso');
          return true;
        } else {
          throw Exception(data['message'] ?? 'Erro ao redefinir senha');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO AO REDEFINIR SENHA: $mensagemErro');
      rethrow;
    }
  }

  // ========== ATUALIZAÇÃO DE PERFIL ==========

  Future<bool> atualizarPerfil(Usuario usuarioAtualizado) async {
    try {
      print('🔄 Atualizando perfil...');
      print('👤 User ID: ${usuarioAtualizado.id}');
      print('📦 Dados: ${usuarioAtualizado.toMapParaAtualizacao()}');

      if (usuarioEstaBanido) {
        throw Exception('🚫 Conta banida. Não é possível atualizar o perfil.');
      }

      final response = await http
          .put(
            Uri.parse('$_baseUrl/api/user/profile'),
            headers: _headers,
            body: json.encode(usuarioAtualizado.toMapParaAtualizacao()),
          )
          .timeout(const Duration(seconds: 15));

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          final usuario = Usuario.fromMap(data['user']);

          if (usuario.banido) {
            await _limparUsuarioSalvo();
            throw Exception('🚫 Sua conta foi banida durante a atualização.');
          }

          await _salvarUsuarioLogado(usuario);
          print('✅ Perfil atualizado com sucesso');
          return true;
        } else {
          throw Exception(data['message'] ?? 'Erro ao atualizar perfil');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(_extrairMensagemErro(errorData));
      }
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ Erro ao atualizar perfil: $mensagemErro');
      rethrow;
    }
  }

  // ========== VERIFICAÇÃO DE BANIMENTO EM TEMPO REAL ==========

  Future<bool> verificarStatusConta() async {
    try {
      if (_usuarioLogado == null) return false;

      final response = await http
          .get(
            Uri.parse('$_baseUrl/api/user/${_usuarioLogado!.id}'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final usuarioAtual = Usuario.fromMap(data['data'] ?? data);

        if (usuarioAtual.banido && !_usuarioLogado!.banido) {
          print('🚫 USUÁRIO BANIDO DURANTE SESSÃO');
          await _limparUsuarioSalvo();
          _usuarioLogado = null;
          return false;
        }

        _usuarioLogado = usuarioAtual;
        await _salvarUsuarioLogado(usuarioAtual);
        return true;
      }
      return false;
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ Erro ao verificar status: $mensagemErro');
      return false;
    }
  }

  // ========== MÉTODOS AUXILIARES ==========

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  String _extrairMensagemErro(Map<String, dynamic> errorData) {
    if (errorData['message'] != null) {
      String mensagem = errorData['message'].toString();
      mensagem = mensagem.replaceAll('Exception: ', '');
      return mensagem;
    }

    if (errorData['errors'] != null) {
      final errors = errorData['errors'] as Map<String, dynamic>;
      final firstError = errors.values.first;
      if (firstError is List) {
        String mensagem = firstError.first.toString();
        mensagem = mensagem.replaceAll('Exception: ', '');
        return mensagem;
      }
      String mensagem = firstError.toString();
      mensagem = mensagem.replaceAll('Exception: ', '');
      return mensagem;
    }

    return 'Erro desconhecido';
  }

  Future<void> _salvarUsuarioLogado(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, usuario.toJson());
    _usuarioLogado = usuario;
  }

  Future<void> _limparUsuarioSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _usuarioLogado = null;
  }

  // ========== TESTES ==========

  Future<void> testarConexao() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/api/animais'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      print('🔗 Conexão API: ${response.statusCode == 200 ? "✅" : "❌"}');
    } catch (e) {
      String mensagemErro = e.toString().replaceAll('Exception: ', '');
      print('❌ ERRO CONEXÃO: $mensagemErro');
    }
  }

  static Future<void> limparLoginSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

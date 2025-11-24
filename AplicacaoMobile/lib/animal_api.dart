import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'animal.dart';
import 'api_service.dart';
import 'autenticacao.dart';

class AnimalApiService {
  static const String baseUrl = 'http://192.168.15.16:8000/api';

  // ================================
  //   FLUTTER → LARAVEL
  // ================================
  static Map<String, dynamic> animalToMap(Animal animal) {
    final map = {
      'nome': animal.nome,
      'descricao': animal.descricao,
      'raca': animal.raca,
      'cor': animal.cor,
      'especie': animal.especie,
      'sexo': animal.sexo,
      'cidade': animal.cidade,
      'bairro': animal.bairro,
      'user_id': animal.donoId,
      'situacao': animal.tipo, // 'perdido' ou 'encontrado'
      'ativo': animal.ativo,
    };

    // Campos específicos para animais PERDIDOS
    if (animal.isPerdido) {
      map['ultimo_local_visto'] = animal.ultimoLocalVisto ?? '';
      map['endereco_desaparecimento'] = animal.enderecoDesaparecimento ?? '';
      map['data_desaparecimento'] = animal.dataDesaparecimento ?? '';
      map['status'] = 'pendente';
    }

    // Campos específicos para animais ENCONTRADOS
    if (animal.isEncontrado) {
      map['local_encontro'] = animal.localEncontro ?? '';
      map['endereco_encontro'] = animal.enderecoEncontro ?? '';
      map['data_encontro'] = animal.dataEncontro ?? '';
      map['situacao_saude'] = animal.situacaoSaude ?? 'Não avaliado';
      map['contato_responsavel'] = animal.contatoResponsavel ?? '';
      map['status'] = 'pendente';
    }

    return map;
  }

  // ================================
  //   DEBUG COMPLETO DA ESTRUTURA
  // ================================
  static void _debugEstruturaCompleta(Map<String, dynamic> map) {
    print('🕵️‍♂️ === DEBUG COMPLETO DA ESTRUTURA ===');

    // 1. Todas as chaves disponíveis
    print('🔑 TODAS AS CHAVES: ${map.keys.toList()}');

    // 2. Foca nas chaves relacionadas a usuário
    final userKeys = map.keys
        .where(
          (key) =>
              key.contains('user') ||
              key.contains('tel') ||
              key.contains('phone') ||
              key.contains('nome') ||
              key.contains('name') ||
              key.contains('email'),
        )
        .toList();

    print('👤 CHAVES DO USUÁRIO: $userKeys');

    // 3. Mostra valores das chaves do usuário
    for (var key in userKeys) {
      print('   $key: ${map[key]} (tipo: ${map[key]?.runtimeType})');
    }

    // 4. Analisa objeto user se existir
    if (map['user'] != null) {
      print('👥 OBJETO USER ENCONTRADO:');
      if (map['user'] is Map) {
        final userMap = Map<String, dynamic>.from(map['user']);
        print('   Chaves do user: ${userMap.keys.toList()}');
        for (var key in userMap.keys) {
          print(
            '   user.$key: ${userMap[key]} (tipo: ${userMap[key]?.runtimeType})',
          );
        }
      } else {
        print('   user é do tipo: ${map['user'].runtimeType}');
      }
    } else {
      print('👥 OBJETO USER: NÃO ENCONTRADO');
    }

    // 5. Verifica se há relacionamentos aninhados
    final relacionamentos = map.keys
        .where(
          (key) =>
              key.contains('usuario') ||
              key.contains('owner') ||
              key.contains('dono'),
        )
        .toList();

    if (relacionamentos.isNotEmpty) {
      print('🔗 RELACIONAMENTOS ENCONTRADOS: $relacionamentos');
      for (var rel in relacionamentos) {
        print('   $rel: ${map[rel]}');
      }
    }

    print('🕵️‍♂️ === FIM DEBUG ===');
  }

  // ================================
  //   LARAVEL → FLUTTER
  // ================================
  static Animal mapToAnimal(Map<String, dynamic> map) {
    print('🔄 MAP TO ANIMAL - INICIANDO');

    //  DEBUG COMPLETO ANTES DE PROCESSAR
    _debugEstruturaCompleta(map);

    // DADOS DO USUÁRIO
    String? userNome;
    String? userTelefone;
    String? userEmail;

    // 1. Tenta campos diretos (user_nome, user_telefone, etc)
    userNome = map['user_nome']?.toString();
    userTelefone = map['user_telefone']?.toString();
    userEmail = map['user_email']?.toString();

    print('📍 Campos diretos - Nome: "$userNome", Telefone: "$userTelefone"');

    // 2. Tenta do objeto user se existir
    if (map['user'] != null) {
      print('📍 Objeto user encontrado: ${map['user']}');

      if (map['user'] is Map) {
        final userMap = Map<String, dynamic>.from(map['user']);
        print('📍 Chaves do user object: ${userMap.keys.toList()}');

        // Procura por 'tel' e 'telefone' em todas as variações
        userNome ??=
            userMap['nome']?.toString() ??
            userMap['name']?.toString() ??
            userMap['user_nome']?.toString();

        userTelefone ??=
            userMap['telefone']?.toString() ??
            userMap['tel']?.toString() ??
            userMap['phone']?.toString() ??
            userMap['user_telefone']?.toString();

        userEmail ??=
            userMap['email']?.toString() ?? userMap['user_email']?.toString();

        print(
          '📍 Após user object - Nome: "$userNome", Telefone: "$userTelefone"',
        );
      }
    }

    // 3. Tenta campos alternativos
    userNome ??= map['nome_usuario']?.toString();
    userTelefone ??= map['telefone_usuario']?.toString();
    userEmail ??= map['email_usuario']?.toString();

    // 4. Busca em TODOS os campos do map (última tentativa)
    print('🔍 BUSCA EM TODOS OS CAMPOS:');
    map.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        if (key.contains('tel') || key.contains('phone')) {
          print('   📞 Campo telefone encontrado: $key = $value');
          userTelefone ??= value.toString();
        }
        if (key.contains('nome') || key.contains('name')) {
          print('   👤 Campo nome encontrado: $key = $value');
          userNome ??= value.toString();
        }
      }
    });

    print('DADOS FINAIS DO USUÁRIO:');
    print('   Nome: "$userNome"');
    print('   Telefone: "$userTelefone"');
    print('   Email: "$userEmail"');

    return Animal(
      id: map['id']?.toString() ?? '',
      nome: map['nome'] ?? 'Não identificado',
      descricao: map['descricao'] ?? '',
      raca: map['raca'] ?? '',
      cor: map['cor'] ?? '',
      especie: map['especie'] ?? '',
      sexo: map['sexo'] ?? '',
      imagens: _parseImagens(map),
      cidade: map['cidade'] ?? '',
      bairro: map['bairro'] ?? '',
      donoId: map['user_id']?.toString() ?? '',

      dataCriacao: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      dataAtualizacao: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : DateTime.now(),
      ativo: map['ativo'] == true,

      // DADOS DO USUÁRIO
      userNome: userNome?.isNotEmpty == true ? userNome : null,
      userTelefone: userTelefone?.isNotEmpty == true ? userTelefone : null,
      userEmail: userEmail?.isNotEmpty == true ? userEmail : null,

      // Tipo do animal
      tipo: map['situacao'] ?? 'perdido',

      // Campos para animais PERDIDOS
      ultimoLocalVisto: map['ultimo_local_visto'],
      enderecoDesaparecimento: map['endereco_desaparecimento'],
      dataDesaparecimento: map['data_desaparecimento'],

      // Campos para animais ENCONTRADOS
      localEncontro: map['local_encontro'],
      enderecoEncontro: map['endereco_encontro'],
      dataEncontro: map['data_encontro'],
      situacaoSaude: map['situacao_saude'],
      contatoResponsavel: map['contato_responsavel'],
    );
  }

  // ================================
  //     PROCESSAR IMAGENS
  // ================================
  static List<String> _parseImagens(Map<String, dynamic> map) {
    if (map['imagens'] == null) return ['assets/cachorro1.png'];

    try {
      if (map['imagens'] is List) {
        return List<String>.from(map['imagens']);
      }

      if (map['imagens'] is String) {
        final decoded = json.decode(map['imagens']);
        if (decoded is List) {
          return List<String>.from(decoded);
        }
      }
    } catch (e) {
      print('❌ Erro ao parsear imagens: $e');
    }

    return ['assets/cachorro1.png'];
  }

  // ================================
  //   DETECTAR TIPO MIME
  // ================================
  static String? _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  // ================================
  //   CADASTRAR ANIMAL (ÚNICO MÉTODO)
  // ================================
  static Future<Animal> cadastrarAnimal(
    Animal animal, {
    List<File> imagens = const [],
  }) async {
    try {
      print('🔄 === INICIANDO CADASTRO ANIMAL ===');
      print('📦 Dados do animal: ${animalToMap(animal)}');

      // Criar requisição multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/animais'),
      );

      // ✅ Adicionar campos do animal
      final animalMap = animalToMap(animal);
      animalMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('📋 Campos enviados: $animalMap');

      // ✅ Adicionar imagens (se fornecidas)
      for (var i = 0; i < imagens.length; i++) {
        final imagem = imagens[i];
        if (await imagem.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('imagens[]', imagem.path),
          );
          print('📸 Imagem ${i + 1}: ${imagem.path}');
        } else {
          print('⚠️  Imagem não encontrada: ${imagem.path}');
        }
      }

      print('📤 Total de arquivos anexados: ${request.files.length}');

      // ✅ Adicionar headers
      final token = AuthService().token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token incluído');
      }
      request.headers['Accept'] = 'application/json';

      // ✅ Enviar requisição com timeout
      print('🚀 Enviando requisição...');
      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: $responseData');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData);
        final animalSalvo = mapToAnimal(data['data'] ?? data);
        print('✅ ANIMAL CADASTRADO COM SUCESSO! ID: ${animalSalvo.id}');
        return animalSalvo;
      } else {
        final errorMsg = _extrairMensagemErro(responseData);
        throw Exception('Erro HTTP ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ ERRO NO CADASTRO ANIMAL: $e');
      rethrow;
    }
  }

  // ================================
  //   CADASTRAR ANIMAL PERDIDO COM IMAGENS
  // ================================
  static Future<Animal> cadastrarAnimalPerdido({
    required Animal animal,
    required List<File> imagens,
  }) async {
    try {
      print('🔄 === INICIANDO CADASTRO ANIMAL PERDIDO ===');
      print('📦 Dados do animal: ${animalToMap(animal)}');

      // Criar requisição multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/animais'),
      );

      // ✅ Adicionar campos do animal
      final animalMap = animalToMap(animal);
      animalMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('📋 Campos enviados: $animalMap');

      // ✅ Adicionar imagens
      for (var i = 0; i < imagens.length; i++) {
        final imagem = imagens[i];
        if (await imagem.exists()) {
          final mimeType = _getMimeType(imagem.path);
          request.files.add(
            await http.MultipartFile.fromPath('imagens[]', imagem.path),
          );
          print('📸 Imagem ${i + 1}: ${imagem.path} (${mimeType ?? 'auto'})');
        } else {
          print('⚠️  Imagem não encontrada: ${imagem.path}');
        }
      }

      print('📤 Total de arquivos anexados: ${request.files.length}');

      // ✅ Adicionar headers
      final token = AuthService().token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token incluído');
      }
      request.headers['Accept'] = 'application/json';

      // ✅ Enviar requisição com timeout
      print('🚀 Enviando requisição...');
      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: $responseData');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData);
        final animalSalvo = mapToAnimal(data['data'] ?? data);
        print('✅ ANIMAL PERDIDO CADASTRADO COM SUCESSO! ID: ${animalSalvo.id}');
        return animalSalvo;
      } else {
        final errorMsg = _extrairMensagemErro(responseData);
        throw Exception('Erro HTTP ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ ERRO NO CADASTRO ANIMAL PERDIDO: $e');
      rethrow;
    }
  }

  // ================================
  //   CADASTRAR ANIMAL ENCONTRADO COM IMAGENS
  // ================================
  static Future<Animal> cadastrarAnimalEncontrado({
    required Animal animal,
    required List<File> imagens,
  }) async {
    try {
      print('🔄 === INICIANDO CADASTRO ANIMAL ENCONTRADO ===');
      print('📦 Dados do animal: ${animalToMap(animal)}');

      // Criar requisição multipart
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/animais'),
      );

      // ✅ Adicionar campos do animal
      final animalMap = animalToMap(animal);
      animalMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('📋 Campos enviados: $animalMap');

      // ✅ Adicionar imagens
      for (var i = 0; i < imagens.length; i++) {
        final imagem = imagens[i];
        if (await imagem.exists()) {
          final mimeType = _getMimeType(imagem.path);
          request.files.add(
            await http.MultipartFile.fromPath('imagens[]', imagem.path),
          );
          print('📸 Imagem ${i + 1}: ${imagem.path} (${mimeType ?? 'auto'})');
        } else {
          print('⚠️  Imagem não encontrada: ${imagem.path}');
        }
      }

      print('📤 Total de arquivos anexados: ${request.files.length}');

      // ✅ Adicionar headers
      final token = AuthService().token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token incluído');
      }
      request.headers['Accept'] = 'application/json';

      // ✅ Enviar requisição com timeout
      print('🚀 Enviando requisição...');
      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: $responseData');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData);
        final animalSalvo = mapToAnimal(data['data'] ?? data);
        print('✅ ANIMAL CADASTRADO COM SUCESSO! ID: ${animalSalvo.id}');
        return animalSalvo;
      } else {
        final errorMsg = _extrairMensagemErro(responseData);
        throw Exception('Erro HTTP ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ ERRO NO CADASTRO ANIMAL ENCONTRADO: $e');
      rethrow;
    }
  }

  // ================================
  // ATUALIZAR ANIMAL COM IMAGENS
  // ================================
  static Future<Animal> atualizarAnimalComImagens({
    required Animal animal,
    List<File>? novasImagens,
  }) async {
    try {
      print('🔄 === ATUALIZANDO ANIMAL COM IMAGENS ===');
      print('📦 Dados do animal: ${animalToMap(animal)}');
      print('📸 Novas imagens: ${novasImagens?.length ?? 0}');

      // Criar requisição multipart
      var request = http.MultipartRequest(
        'POST', // Laravel geralmente usa POST com _method=PUT
        Uri.parse('$baseUrl/animais/${animal.id}'),
      );

      // ✅ Adicionar método PUT para Laravel
      request.fields['_method'] = 'PUT';

      // ✅ Adicionar campos do animal
      final animalMap = animalToMap(animal);
      animalMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('📋 Campos enviados: $animalMap');

      // ✅ Adicionar novas imagens (se fornecidas)
      if (novasImagens != null && novasImagens.isNotEmpty) {
        for (var i = 0; i < novasImagens.length; i++) {
          final imagem = novasImagens[i];
          if (await imagem.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath('imagens[]', imagem.path),
            );
            print('📸 Nova imagem ${i + 1}: ${imagem.path}');
          } else {
            print('⚠️  Nova imagem não encontrada: ${imagem.path}');
          }
        }
      }

      print('📤 Total de arquivos anexados: ${request.files.length}');

      // ✅ Adicionar headers
      final token = AuthService().token;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token incluído');
      }
      request.headers['Accept'] = 'application/json';

      // ✅ Enviar requisição com timeout
      print('🚀 Enviando requisição de atualização...');
      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseData = await response.stream.bytesToString();

      print('📡 STATUS: ${response.statusCode}');
      print('📦 RESPOSTA: $responseData');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(responseData);
        final animalAtualizado = mapToAnimal(data['data'] ?? data);
        print('✅ ANIMAL ATUALIZADO COM SUCESSO! ID: ${animalAtualizado.id}');
        return animalAtualizado;
      } else {
        final errorMsg = _extrairMensagemErro(responseData);
        throw Exception('Erro HTTP ${response.statusCode}: $errorMsg');
      }
    } catch (e) {
      print('❌ ERRO AO ATUALIZAR ANIMAL: $e');
      rethrow;
    }
  }

  // ================================
  //   EXTRAR MENSAGEM DE ERRO
  // ================================
  static String _extrairMensagemErro(String responseData) {
    try {
      final data = json.decode(responseData);
      if (data['message'] != null) return data['message'];
      if (data['error'] != null) return data['error'];
      if (data['errors'] != null) return data['errors'].toString();
    } catch (e) {
      return responseData;
    }
    return 'Erro desconhecido';
  }

  // ================================
  //   BUSCAR ANIMAIS
  // ================================
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
    String? donoId,
    String? status,
  }) async {
    try {
      final params = <String, String>{};

      if (tipo != null) params['situacao'] = tipo;
      if (cidade != null && cidade != 'Todas') params['cidade'] = cidade;
      if (donoId != null) params['user_id'] = donoId;
      if (status != null) params['status'] = status;

      String endpoint = 'animais';
      if (params.isNotEmpty) {
        endpoint += '?${Uri(queryParameters: params).query}';
      }

      print('🔍 Buscando animais: $endpoint');
      final response = await ApiService.get(endpoint);
      final data = json.decode(response.body);

      // ✅ DEBUG DA RESPOSTA DA API
      print('📡 API RESPONSE - Status: ${response.statusCode}');

      List list;
      if (data is List) {
        list = data;
      } else if (data is Map && data.containsKey('data')) {
        list = data['data'];
      } else {
        print('📭 Nenhum dado retornado');
        return [];
      }

      print('🐕 Total de animais na resposta: ${list.length}');

      final animais = list.map((item) => mapToAnimal(item)).toList();
      print('✅ ${animais.length} animais mapeados');

      // ✅ DEBUG DOS ANIMAIS MAPEADOS
      if (animais.isNotEmpty) {
        print('📞 PRIMEIRO ANIMAL MAPEADO:');
        print('   Nome: ${animais.first.nome}');
        print('   Telefone: ${animais.first.userTelefone}');
        print('   Dono: ${animais.first.userNome}');
        print('   Email: ${animais.first.userEmail}');
      }

      return animais;
    } catch (e) {
      print('❌ Erro ao buscar animais: $e');
      return [];
    }
  }

  // ================================
  //   MÉTODOS ESPECÍFICOS
  // ================================

  // ✅ BUSCAR ANIMAIS APROVADOS (público)
  static Future<List<Animal>> buscarAnimaisAprovados({String? tipo}) async {
    return await buscarAnimais(tipo: tipo, status: 'ativo');
  }

  // ✅ BUSCAR ANIMAIS PENDENTES (admin)
  static Future<List<Animal>> buscarAnimaisPendentes({String? tipo}) async {
    return await buscarAnimais(tipo: tipo, status: 'pendente');
  }

  // ✅ BUSCAR ANIMAL POR ID
  static Future<Animal?> buscarAnimalPorId(String id) async {
    try {
      print('🔍 Buscando animal ID: $id');
      final response = await ApiService.get('animais/$id');
      final data = json.decode(response.body);

      final animal = mapToAnimal(data);
      print('✅ Animal encontrado: ${animal.nome}');
      print('   Telefone: ${animal.userTelefone}');
      print('   Dono: ${animal.userNome}');
      return animal;
    } catch (e) {
      print('❌ Erro ao buscar animal: $e');
      return null;
    }
  }

  // ✅ ATUALIZAR ANIMAL
  static Future<Animal> atualizarAnimal(Animal animal) async {
    try {
      print('🔄 Atualizando animal ID: ${animal.id}');
      final response = await ApiService.put(
        'animais/${animal.id}',
        animalToMap(animal),
      );
      final data = json.decode(response.body);
      final animalAtualizado = mapToAnimal(data['data'] ?? data);
      print('✅ Animal atualizado: ${animalAtualizado.id}');
      return animalAtualizado;
    } catch (e) {
      print('❌ Erro ao atualizar animal: $e');
      rethrow;
    }
  }

  // ✅ EXCLUIR ANIMAL
  static Future<bool> excluirAnimal(String id) async {
    try {
      print('🗑️  Excluindo animal ID: $id');
      await ApiService.delete('animais/$id');
      print('✅ Animal excluído: $id');
      return true;
    } catch (e) {
      print('❌ Erro ao excluir animal: $e');
      return false;
    }
  }

  // ✅ MEUS ANIMAIS
  static Future<List<Animal>> meusAnimais(String donoId) async {
    return await buscarAnimais(donoId: donoId);
  }

  // ✅ ANIMAIS POR TIPO (apenas aprovados)
  static Future<List<Animal>> buscarAnimaisPorTipo(String tipo) async {
    return await buscarAnimaisAprovados(tipo: tipo);
  }

  // ✅ APROVAR ANIMAL (admin)
  static Future<Animal> aprovarAnimal(String animalId) async {
    try {
      print('✅ Aprovando animal ID: $animalId');
      final response = await ApiService.put('animais/$animalId/aprovar', {});
      final data = json.decode(response.body);
      final animalAprovado = mapToAnimal(data['data'] ?? data);
      print('✅ Animal aprovado: ${animalAprovado.id}');
      return animalAprovado;
    } catch (e) {
      print('❌ Erro ao aprovar animal: $e');
      rethrow;
    }
  }

  // ✅ REJEITAR ANIMAL (admin)
  static Future<Animal> rejeitarAnimal(String animalId) async {
    try {
      print('❌ Rejeitando animal ID: $animalId');
      final response = await ApiService.put('animais/$animalId/rejeitar', {});
      final data = json.decode(response.body);
      final animalRejeitado = mapToAnimal(data['data'] ?? data);
      print('✅ Animal rejeitado: ${animalRejeitado.id}');
      return animalRejeitado;
    } catch (e) {
      print('❌ Erro ao rejeitar animal: $e');
      rethrow;
    }
  }

  // ✅ ATUALIZAR STATUS DO ANIMAL
  static Future<Animal> atualizarStatusAnimal({
    required String animalId,
    required String status,
  }) async {
    try {
      print('🔄 Atualizando status do animal $animalId para: $status');
      final response = await ApiService.put('animais/$animalId/status', {
        'status': status,
      });
      final data = json.decode(response.body);
      final animalAtualizado = mapToAnimal(data['data'] ?? data);
      print('✅ Status atualizado: ${animalAtualizado.id} -> $status');
      return animalAtualizado;
    } catch (e) {
      print('❌ Erro ao atualizar status: $e');
      rethrow;
    }
  }

  // ✅ OBTER ESTATÍSTICAS
  static Future<Map<String, int>> obterEstatisticas() async {
    try {
      final animais = await buscarAnimais();

      final stats = {
        'total': animais.length,
        'perdidos': animais.where((a) => a.isPerdido).length,
        'encontrados': animais.where((a) => a.isEncontrado).length,
        'cachorros': animais
            .where((a) => a.especie.toLowerCase() == 'cachorro')
            .length,
        'gatos': animais.where((a) => a.especie.toLowerCase() == 'gato').length,
        'recentes': animais
            .where(
              (a) => a.dataCriacao!.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
            )
            .length,
      };

      return stats;
    } catch (e) {
      print('❌ Erro ao obter estatísticas: $e');
      return {
        'total': 0,
        'perdidos': 0,
        'encontrados': 0,
        'cachorros': 0,
        'gatos': 0,
        'recentes': 0,
      };
    }
  }
}

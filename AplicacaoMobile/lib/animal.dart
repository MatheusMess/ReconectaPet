import 'dart:convert';
import 'animal_api.dart';

class Animal {
  final String id;
  final String nome;
  final String descricao;
  final String raca;
  final String cor;
  final String especie;
  final String sexo;
  final List<String> imagens;
  final String cidade;
  final String bairro;
  final DateTime? dataCriacao;
  final DateTime? dataAtualizacao;
  final bool ativo;

  // Campos para animais perdidos
  final String? ultimoLocalVisto;
  final String? enderecoDesaparecimento;
  final String? dataDesaparecimento;

  // Campos para animais encontrados
  final String? localEncontro;
  final String? enderecoEncontro;
  final String? dataEncontro;
  final String? situacaoSaude;
  final String? contatoResponsavel;

  // Campos de usuário
  final String donoId;
  final String? userNome;
  final String? userTelefone;
  final String? userEmail;
  final String tipo;

  // Novos campos do Laravel
  final String situacao;
  final String status;

  Animal({
    String? id,
    required this.nome,
    required this.descricao,
    required this.raca,
    required this.cor,
    required this.especie,
    required this.sexo,
    required this.imagens,
    required this.cidade,
    required this.bairro,
    required this.donoId,

    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    this.ativo = true,

    this.userNome,
    this.userTelefone,
    this.userEmail,
    this.tipo = 'perdido',

    this.ultimoLocalVisto,
    this.enderecoDesaparecimento,
    this.dataDesaparecimento,

    this.localEncontro,
    this.enderecoEncontro,
    this.dataEncontro,
    this.situacaoSaude,
    this.contatoResponsavel,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       dataCriacao = dataCriacao ?? DateTime.now(),
       dataAtualizacao = dataAtualizacao ?? DateTime.now(),
       situacao = tipo, // Compatibilidade com Laravel
       status = 'pendente'; // Default do Laravel

  // ✅ FACTORY METHOD COMPATÍVEL COM ANIMAL_API
  factory Animal.fromJson(Map<String, dynamic> json) {
    print('🔄 ANIMAL.FROMJSON - Dados recebidos:');
    print('   Todas as chaves: ${json.keys.toList()}');

    // ✅ Dados do usuário (compatível com animal_api.dart)
    String? userNome;
    String? userTelefone;
    String? userEmail;

    // 1. Tenta campos diretos
    userNome = json['user_nome']?.toString();
    userTelefone = json['user_telefone']?.toString();
    userEmail = json['user_email']?.toString();

    // 2. Tenta do objeto user
    if (json['user'] != null) {
      print('   📍 Objeto user encontrado: ${json['user']}');

      if (json['user'] is Map) {
        final userMap = Map<String, dynamic>.from(json['user']);
        userNome ??= userMap['nome']?.toString();
        userTelefone ??=
            userMap['telefone']?.toString() ?? userMap['tel']?.toString();
        userEmail ??= userMap['email']?.toString();
      }
    }

    // 3. Tenta campos alternativos
    userNome ??= json['nome_usuario']?.toString();
    userTelefone ??= json['telefone_usuario']?.toString();
    userEmail ??= json['email_usuario']?.toString();

    print('   ✅ Dados finais - Nome: "$userNome", Telefone: "$userTelefone"');

    return Animal(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? 'Não identificado',
      descricao: json['descricao'] ?? '',
      raca: json['raca'] ?? '',
      cor: json['cor'] ?? '',
      especie: json['especie'] ?? '',
      sexo: json['sexo'] ?? '',
      imagens: _parseImagens(json),
      cidade: json['cidade'] ?? '',
      bairro: json['bairro'] ?? '',
      donoId: json['user_id']?.toString() ?? '',

      dataCriacao: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      dataAtualizacao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      ativo: json['ativo'] == true,

      // ✅ Dados do usuário
      userNome: userNome?.isNotEmpty == true ? userNome : null,
      userTelefone: userTelefone?.isNotEmpty == true ? userTelefone : null,
      userEmail: userEmail?.isNotEmpty == true ? userEmail : null,

      // Tipo do animal (compatível com Laravel)
      tipo: json['situacao'] ?? 'perdido',

      // Campos para animais PERDIDOS
      ultimoLocalVisto: json['ultimo_local_visto'],
      enderecoDesaparecimento: json['endereco_desaparecimento'],
      dataDesaparecimento: json['data_desaparecimento'],

      // Campos para animais ENCONTRADOS
      localEncontro: json['local_encontro'],
      enderecoEncontro: json['endereco_encontro'],
      dataEncontro: json['data_encontro'],
      situacaoSaude: json['situacao_saude'],
      contatoResponsavel: json['contato_responsavel'],
    );
  }

  // ✅ MÉTODO PARA CONVERTER PARA JSON (compatível com animal_api.dart)
  Map<String, dynamic> toJson() {
    final map = {
      'nome': nome,
      'descricao': descricao,
      'raca': raca,
      'cor': cor,
      'especie': especie,
      'sexo': sexo,
      'cidade': cidade,
      'bairro': bairro,
      'user_id': donoId,
      'situacao': tipo,
      'ativo': ativo,
    };

    // Campos específicos para animais PERDIDOS
    if (isPerdido) {
      map['ultimo_local_visto'] = ultimoLocalVisto ?? '';
      map['endereco_desaparecimento'] = enderecoDesaparecimento ?? '';
      map['data_desaparecimento'] = dataDesaparecimento ?? '';
      map['status'] = 'pendente';
    }

    // Campos específicos para animais ENCONTRADOS
    if (isEncontrado) {
      map['local_encontro'] = localEncontro ?? '';
      map['endereco_encontro'] = enderecoEncontro ?? '';
      map['data_encontro'] = dataEncontro ?? '';
      map['situacao_saude'] = situacaoSaude ?? 'Não avaliado';
      map['contato_responsavel'] = contatoResponsavel ?? '';
      map['status'] = 'pendente';
    }

    return map;
  }

  // ✅ MÉTODO PARA PARSER DE IMAGENS CORRIGIDO
  static List<String> _parseImagens(Map<String, dynamic> json) {
    final imagensData = json['imagens'];

    if (imagensData == null) {
      return ['assets/cachorro1.png'];
    }

    // Se já for uma lista
    if (imagensData is List) {
      return List<String>.from(imagensData.map((img) => img.toString()));
    }

    // Se for string, tenta decodificar JSON
    if (imagensData is String) {
      try {
        // ✅ CORREÇÃO: json.decode só funciona com String, não com Map
        final decoded = jsonDecode(imagensData);
        if (decoded is List) {
          return List<String>.from(decoded.map((img) => img.toString()));
        }
      } catch (e) {
        print('❌ Erro ao decodificar JSON de imagens: $e');
        // Se não for JSON válido, trata como string única
        return [imagensData];
      }
    }

    // Fallback
    return ['assets/cachorro1.png'];
  }

  // ✅ GETTERS (compatíveis com telas existentes)
  String get imagemPrincipal =>
      imagens.isNotEmpty ? imagens[0] : "assets/cachorro1.png";

  bool get isPerdido => tipo == 'perdido';
  bool get isEncontrado => tipo == 'encontrado';
  bool get isAtivo => status == 'ativo';
  bool get isPendente => status == 'pendente';

  String get localizacaoDisplay {
    if (isPerdido) {
      return ultimoLocalVisto ?? 'Local desconhecido';
    } else {
      return localEncontro ?? 'Local de encontro';
    }
  }

  String get enderecoDisplay {
    if (isPerdido) {
      return enderecoDesaparecimento ?? 'Endereço não informado';
    } else {
      return enderecoEncontro ?? 'Endereço não informado';
    }
  }

  String get dataDisplay {
    if (isPerdido) {
      return dataDesaparecimento ?? 'Data não informada';
    } else {
      return dataEncontro ?? 'Data não informada';
    }
  }

  String get telefoneContato {
    if (isEncontrado && contatoResponsavel != null) {
      return contatoResponsavel!;
    }
    return userTelefone ?? '';
  }

  String get nomeUsuario => userNome ?? 'Usuário';

  String get localizacaoCompleta {
    List<String> partes = [];
    if (bairro.isNotEmpty) partes.add(bairro);
    if (cidade.isNotEmpty) partes.add(cidade);
    return partes.join(', ');
  }

  String get statusDisplay {
    if (isPerdido) return 'Perdido';
    if (isEncontrado) return 'Encontrado';
    return 'Desconhecido';
  }

  bool get isRecente {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataCriacao ?? agora);
    return diferenca.inDays <= 7;
  }

  String get dataFormatada {
    if (dataCriacao != null) {
      final now = DateTime.now();
      final difference = now.difference(dataCriacao!);

      if (difference.inDays == 0) {
        return 'Hoje';
      } else if (difference.inDays == 1) {
        return 'Ontem';
      } else if (difference.inDays < 7) {
        return 'Há ${difference.inDays} dias';
      } else {
        return '${dataCriacao!.day}/${dataCriacao!.month}/${dataCriacao!.year}';
      }
    }
    return dataDisplay;
  }

  // ✅ MÉTODOS DE CÓPIA
  Animal copyWith({
    String? id,
    String? nome,
    String? descricao,
    String? raca,
    String? cor,
    String? especie,
    String? sexo,
    List<String>? imagens,
    String? cidade,
    String? bairro,
    String? donoId,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    bool? ativo,
    String? userNome,
    String? userTelefone,
    String? userEmail,
    String? tipo,
    String? ultimoLocalVisto,
    String? enderecoDesaparecimento,
    String? dataDesaparecimento,
    String? localEncontro,
    String? enderecoEncontro,
    String? dataEncontro,
    String? situacaoSaude,
    String? contatoResponsavel,
  }) {
    return Animal(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      raca: raca ?? this.raca,
      cor: cor ?? this.cor,
      especie: especie ?? this.especie,
      sexo: sexo ?? this.sexo,
      imagens: imagens ?? this.imagens,
      cidade: cidade ?? this.cidade,
      bairro: bairro ?? this.bairro,
      donoId: donoId ?? this.donoId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      ativo: ativo ?? this.ativo,
      userNome: userNome ?? this.userNome,
      userTelefone: userTelefone ?? this.userTelefone,
      userEmail: userEmail ?? this.userEmail,
      tipo: tipo ?? this.tipo,
      ultimoLocalVisto: ultimoLocalVisto ?? this.ultimoLocalVisto,
      enderecoDesaparecimento:
          enderecoDesaparecimento ?? this.enderecoDesaparecimento,
      dataDesaparecimento: dataDesaparecimento ?? this.dataDesaparecimento,
      localEncontro: localEncontro ?? this.localEncontro,
      enderecoEncontro: enderecoEncontro ?? this.enderecoEncontro,
      dataEncontro: dataEncontro ?? this.dataEncontro,
      situacaoSaude: situacaoSaude ?? this.situacaoSaude,
      contatoResponsavel: contatoResponsavel ?? this.contatoResponsavel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Animal(id: $id, nome: $nome, tipo: $tipo, donoId: $donoId, telefone: $userTelefone)';
  }
}

// ✅ SERVICO COMPATÍVEL
class AnimalService {
  // Buscar todos os animais
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
    String? donoId,
  }) async {
    try {
      return await AnimalApiService.buscarAnimais(
        tipo: tipo,
        cidade: cidade,
        donoId: donoId,
      );
    } catch (e) {
      print('❌ Erro no AnimalService.buscarAnimais: $e');
      rethrow;
    }
  }

  // Buscar animal por ID
  static Future<Animal?> buscarAnimalPorId(String id) async {
    try {
      return await AnimalApiService.buscarAnimalPorId(id);
    } catch (e) {
      print('❌ Erro no AnimalService.buscarAnimalPorId: $e');
      rethrow;
    }
  }

  // Cadastrar novo animal
  static Future<Animal> cadastrarAnimal(Animal animal) async {
    try {
      return await AnimalApiService.cadastrarAnimal(animal);
    } catch (e) {
      print('❌ Erro no AnimalService.cadastrarAnimal: $e');
      rethrow;
    }
  }

  // Atualizar animal
  static Future<Animal> atualizarAnimal(Animal animal) async {
    try {
      return await AnimalApiService.atualizarAnimal(animal);
    } catch (e) {
      print('❌ Erro no AnimalService.atualizarAnimal: $e');
      rethrow;
    }
  }

  // Excluir animal
  static Future<bool> excluirAnimal(String id) async {
    try {
      return await AnimalApiService.excluirAnimal(id);
    } catch (e) {
      print('❌ Erro no AnimalService.excluirAnimal: $e');
      rethrow;
    }
  }

  // Buscar animais do usuário
  static Future<List<Animal>> meusAnimais(String donoId) async {
    try {
      return await AnimalApiService.meusAnimais(donoId);
    } catch (e) {
      print('❌ Erro no AnimalService.meusAnimais: $e');
      rethrow;
    }
  }

  // Buscar animais por tipo
  static Future<List<Animal>> buscarAnimaisPorTipo(String tipo) async {
    try {
      return await AnimalApiService.buscarAnimaisPorTipo(tipo);
    } catch (e) {
      print('❌ Erro no AnimalService.buscarAnimaisPorTipo: $e');
      rethrow;
    }
  }

  // Obter estatísticas
  static Future<Map<String, int>> obterEstatisticas({String? donoId}) async {
    try {
      final animais = await buscarAnimais(donoId: donoId);

      return {
        'total': animais.length,
        'perdidos': animais.where((a) => a.isPerdido).length,
        'encontrados': animais.where((a) => a.isEncontrado).length,
        'cachorros': animais
            .where((a) => a.especie.toLowerCase() == 'cachorro')
            .length,
        'gatos': animais.where((a) => a.especie.toLowerCase() == 'gato').length,
        'recentes': animais.where((a) => a.isRecente).length,
      };
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

  // Método vazio para compatibilidade
  static Future<void> carregarDadosIniciais() async {
    // Não faz nada na versão com API
  }
}

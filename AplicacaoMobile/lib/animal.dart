import 'dart:convert';
import 'package:http/http.dart' as http;

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

  // ========== CAMPOS PARA ANIMAIS PERDIDOS ==========
  final String? ultimoLocalVisto; // Apenas para perdidos
  final String? enderecoDesaparecimento; // Apenas para perdidos
  final String? dataDesaparecimento; // Apenas para perdidos

  // ========== CAMPOS PARA ANIMAIS ENCONTRADOS ==========
  final String? localEncontro; // Apenas para encontrados
  final String? enderecoEncontro; // Apenas para encontrados
  final String? dataEncontro; // Apenas para encontrados
  final String? situacaoSaude; // Principalmente para encontrados
  final String? contatoResponsavel; // Principalmente para encontrados

  // ========== CAMPOS DE USUÁRIO ==========
  final String? userId;
  final String? userNome;
  final String? userTelefone;
  final String? userEmail;
  final String tipo; // 'perdido' ou 'encontrado'

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

    // Campos base
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    this.ativo = true,

    // Campos usuário
    this.userId,
    this.userNome,
    this.userTelefone,
    this.userEmail,
    this.tipo = 'perdido',

    // ========== CAMPOS PERDIDOS ==========
    this.ultimoLocalVisto,
    this.enderecoDesaparecimento,
    this.dataDesaparecimento,

    // ========== CAMPOS ENCONTRADOS ==========
    this.localEncontro,
    this.enderecoEncontro,
    this.dataEncontro,
    this.situacaoSaude,
    this.contatoResponsavel,
  }) : id = id ?? '',
       dataCriacao = dataCriacao ?? DateTime.now(),
       dataAtualizacao = dataAtualizacao ?? DateTime.now();

  // ========== GETTERS ESPECÍFICOS ==========

  String get imagemPrincipal =>
      imagens.isNotEmpty ? imagens[0] : "assets/cachorro1.png";

  bool get isPerdido => tipo == 'perdido';
  bool get isEncontrado => tipo == 'encontrado';

  // Localização baseada no tipo
  String get localizacaoDisplay {
    if (isPerdido) {
      return ultimoLocalVisto ?? 'Local desconhecido';
    } else {
      return localEncontro ?? 'Local de encontro';
    }
  }

  // Endereço baseado no tipo
  String get enderecoDisplay {
    if (isPerdido) {
      return enderecoDesaparecimento ?? 'Endereço não informado';
    } else {
      return enderecoEncontro ?? 'Endereço não informado';
    }
  }

  // Data baseada no tipo
  String get dataDisplay {
    if (isPerdido) {
      return dataDesaparecimento ?? 'Data não informada';
    } else {
      return dataEncontro ?? 'Data não informada';
    }
  }

  // Telefone de contato baseado no tipo
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

  // Método para verificar se o animal é recente (últimos 7 dias)
  bool get isRecente {
    final agora = DateTime.now();
    final diferenca = agora.difference(dataCriacao ?? agora);
    return diferenca.inDays <= 7;
  }

  // Formatar data para exibição
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

  // ========== MÉTODOS DE CONVERSÃO ==========

  // Converter para Map (para enviar para API)
  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'nome': nome,
      'descricao': descricao,
      'raca': raca,
      'cor': cor,
      'especie': especie,
      'sexo': sexo,
      'imagens': imagens,
      'cidade': cidade,
      'bairro': bairro,

      // Campos base
      'data_criacao': dataCriacao?.toIso8601String(),
      'data_atualizacao': dataAtualizacao?.toIso8601String(),
      'ativo': ativo,

      // Campos usuário
      'user_id': userId,
      'user_nome': userNome,
      'user_telefone': userTelefone,
      'user_email': userEmail,
      'tipo': tipo,

      // ========== CAMPOS PERDIDOS ==========
      'ultimo_local_visto': ultimoLocalVisto,
      'endereco_desaparecimento': enderecoDesaparecimento,
      'data_desaparecimento': dataDesaparecimento,

      // ========== CAMPOS ENCONTRADOS ==========
      'local_encontro': localEncontro,
      'endereco_encontro': enderecoEncontro,
      'data_encontro': dataEncontro,
      'situacao_saude': situacaoSaude,
      'contato_responsavel': contatoResponsavel,
    };
  }

  // Converter de Map (para receber da API)
  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id']?.toString() ?? '',
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      raca: map['raca'] ?? '',
      cor: map['cor'] ?? '',
      especie: map['especie'] ?? '',
      sexo: map['sexo'] ?? '',
      imagens: List<String>.from(map['imagens'] ?? []),
      cidade: map['cidade'] ?? '',
      bairro: map['bairro'] ?? '',

      // Campos base
      dataCriacao: map['data_criacao'] != null
          ? DateTime.parse(map['data_criacao'])
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'])
          : null,
      ativo: map['ativo'] ?? true,

      // Campos usuário
      userId: map['user_id']?.toString(),
      userNome: map['user_nome'],
      userTelefone: map['user_telefone'],
      userEmail: map['user_email'],
      tipo: map['tipo'] ?? 'perdido',

      // ========== CAMPOS PERDIDOS ==========
      ultimoLocalVisto: map['ultimo_local_visto'],
      enderecoDesaparecimento: map['endereco_desaparecimento'],
      dataDesaparecimento: map['data_desaparecimento'],

      // ========== CAMPOS ENCONTRADOS ==========
      localEncontro: map['local_encontro'],
      enderecoEncontro: map['endereco_encontro'],
      dataEncontro: map['data_encontro'],
      situacaoSaude: map['situacao_saude'],
      contatoResponsavel: map['contato_responsavel'],
    );
  }

  // Converter para JSON
  String toJson() => json.encode(toMap());

  // Converter de JSON
  factory Animal.fromJson(String source) => Animal.fromMap(json.decode(source));

  // Cópia do animal com campos atualizados
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
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    bool? ativo,
    String? userId,
    String? userNome,
    String? userTelefone,
    String? userEmail,
    String? tipo,

    // Campos perdidos
    String? ultimoLocalVisto,
    String? enderecoDesaparecimento,
    String? dataDesaparecimento,

    // Campos encontrados
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
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      ativo: ativo ?? this.ativo,
      userId: userId ?? this.userId,
      userNome: userNome ?? this.userNome,
      userTelefone: userTelefone ?? this.userTelefone,
      userEmail: userEmail ?? this.userEmail,
      tipo: tipo ?? this.tipo,

      // Campos perdidos
      ultimoLocalVisto: ultimoLocalVisto ?? this.ultimoLocalVisto,
      enderecoDesaparecimento:
          enderecoDesaparecimento ?? this.enderecoDesaparecimento,
      dataDesaparecimento: dataDesaparecimento ?? this.dataDesaparecimento,

      // Campos encontrados
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
    return 'Animal(id: $id, nome: $nome, tipo: $tipo, usuario: $userNome)';
  }

  // ========== EXEMPLOS ==========

  // Lista de exemplo atualizada
  static List<Animal> exemplos = [
    // ANIMAIS PERDIDOS
    Animal(
      nome: "Rex",
      descricao:
          "Cachorro perdido no bairro Centro. É muito brincalhão e responde pelo nome.",
      raca: "Vira-lata",
      cor: "Marrom",
      especie: "Cachorro",
      sexo: "Macho",
      imagens: [
        "assets/cachorro1.png",
        "assets/cachorro2.png",
        "assets/cachorro3.jpg",
      ],
      cidade: "São Paulo",
      bairro: "Centro",
      userNome: "Maria Silva",
      userTelefone: "(11) 99999-9999",
      userEmail: "maria@email.com",
      tipo: "perdido",
      // Campos específicos de perdido
      ultimoLocalVisto: "Centro",
      enderecoDesaparecimento: "Rua Principal, 123",
      dataDesaparecimento: "10/08/2025",
    ),
    Animal(
      nome: "Mimi",
      descricao:
          "Cachorro visto pela última vez na Rua A. Estava com coleira azul.",
      raca: "Salsicha",
      cor: "Branco",
      especie: "Cachorro",
      sexo: "Fêmea",
      imagens: ["assets/cachorro1.png", "assets/cachorro5.jpg"],
      cidade: "São Paulo",
      bairro: "Jardim das Flores",
      userNome: "João Santos",
      userTelefone: "(11) 98888-8888",
      userEmail: "joao@email.com",
      tipo: "perdido",
      // Campos específicos de perdido
      ultimoLocalVisto: "Rua A",
      enderecoDesaparecimento: "Rua A, 45",
      dataDesaparecimento: "12/08/2025",
    ),

    // ANIMAIS ENCONTRADOS
    Animal(
      nome: "Não identificado",
      descricao:
          "Gato encontrado na praça. Muito dócil e com olhos verdes. Procura-se dono.",
      raca: "SRD",
      cor: "Cinza",
      especie: "Gato",
      sexo: "Macho",
      imagens: ["assets/cachorro1.png"],
      cidade: "Rio de Janeiro",
      bairro: "Copacabana",
      userNome: "Ana Oliveira",
      userTelefone: "(21) 97777-7777",
      userEmail: "ana@email.com",
      tipo: "encontrado",
      // Campos específicos de encontrado
      localEncontro: "Praça Central",
      enderecoEncontro: "Praça Central, s/n",
      dataEncontro: "11/08/2025",
      situacaoSaude: "Saudável",
      contatoResponsavel: "(21) 96666-6666",
    ),
  ];
}

// Serviço para gerenciar animais com a API
class AnimalService {
  static const String _baseUrl = 'https://seu-site-laravel.com/api';
  static String? _token;

  // Configurar token de autenticação
  static void setToken(String token) {
    _token = token;
  }

  // Headers para requisições
  static Map<String, String> get _headers {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Buscar todos os animais
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
  }) async {
    try {
      String url = '$_baseUrl/animais';
      List<String> parametros = [];

      if (tipo != null) parametros.add('tipo=$tipo');
      if (cidade != null) parametros.add('cidade=$cidade');
      parametros.add('ativo=true');

      if (parametros.isNotEmpty) {
        url += '?${parametros.join('&')}';
      }

      final response = await http.get(Uri.parse(url), headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Animal.fromMap(item)).toList();
      } else {
        throw Exception('Erro ao buscar animais: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no AnimalService.buscarAnimais: $e');
      throw Exception('Erro ao carregar animais');
    }
  }

  // Buscar animal por ID
  static Future<Animal?> buscarAnimalPorId(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/animais/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Animal.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Erro ao buscar animal: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no AnimalService.buscarAnimalPorId: $e');
      throw Exception('Erro ao carregar animal');
    }
  }

  // Cadastrar novo animal
  static Future<Animal> cadastrarAnimal(Animal animal) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/animais'),
        headers: _headers,
        body: json.encode(animal.toMap()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Animal.fromMap(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao cadastrar animal');
      }
    } catch (e) {
      print('Erro no AnimalService.cadastrarAnimal: $e');
      throw Exception('Erro ao cadastrar animal');
    }
  }

  // Atualizar animal
  static Future<Animal> atualizarAnimal(Animal animal) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/animais/${animal.id}'),
        headers: _headers,
        body: json.encode(animal.toMap()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Animal.fromMap(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao atualizar animal');
      }
    } catch (e) {
      print('Erro no AnimalService.atualizarAnimal: $e');
      throw Exception('Erro ao atualizar animal');
    }
  }

  // Excluir animal (marcar como inativo)
  static Future<bool> excluirAnimal(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/animais/$id'),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro no AnimalService.excluirAnimal: $e');
      throw Exception('Erro ao excluir animal');
    }
  }

  // Buscar animais do usuário logado
  static Future<List<Animal>> meusAnimais() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/meus-animais'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Animal.fromMap(item)).toList();
      } else {
        throw Exception('Erro ao buscar meus animais: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro no AnimalService.meusAnimais: $e');
      throw Exception('Erro ao carregar meus animais');
    }
  }
}

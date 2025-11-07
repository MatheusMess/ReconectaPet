import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String donoId; // ID do usuário que cadastrou o animal (OBRIGATÓRIO)
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
    required this.donoId, // Agora é obrigatório
    // Campos base
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    this.ativo = true,

    // Campos usuário
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
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
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

  // Converter para Map (para armazenar no SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'dono_id': donoId, // ID do dono
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

  // Converter de Map (para carregar do SharedPreferences)
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
      donoId: map['dono_id'] ?? '', // ID do dono
      // Campos base
      dataCriacao: map['data_criacao'] != null
          ? DateTime.parse(map['data_criacao'])
          : null,
      dataAtualizacao: map['data_atualizacao'] != null
          ? DateTime.parse(map['data_atualizacao'])
          : null,
      ativo: map['ativo'] ?? true,

      // Campos usuário
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
    String? donoId,
    DateTime? dataCriacao,
    DateTime? dataAtualizacao,
    bool? ativo,
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
      donoId: donoId ?? this.donoId,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      ativo: ativo ?? this.ativo,
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
    return 'Animal(id: $id, nome: $nome, tipo: $tipo, donoId: $donoId)';
  }

  // ========== EXEMPLOS ==========

  // Lista de exemplos removida
  static List<Animal> exemplos = [];
}

// Serviço para gerenciar animais com armazenamento interno
class AnimalService {
  static const String _storageKey = 'animais_salvos';

  // Salvar lista de animais no SharedPreferences
  static Future<void> _salvarAnimais(List<Animal> animais) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final listaMap = animais.map((animal) => animal.toMap()).toList();
      await prefs.setString(_storageKey, json.encode(listaMap));
    } catch (e) {
      print('Erro ao salvar animais: $e');
      throw Exception('Erro ao salvar dados localmente');
    }
  }

  // Carregar lista de animais do SharedPreferences
  static Future<List<Animal>> _carregarAnimais() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final animaisJson = prefs.getString(_storageKey);

      if (animaisJson == null) {
        return [];
      }

      final List<dynamic> listaMap = json.decode(animaisJson);
      return listaMap.map((map) => Animal.fromMap(map)).toList();
    } catch (e) {
      print('Erro ao carregar animais: $e');
      return [];
    }
  }

  // Buscar todos os animais
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
    String? donoId, // Filtro opcional por dono
  }) async {
    try {
      List<Animal> todosAnimais = await _carregarAnimais();

      // Aplicar filtros
      if (tipo != null) {
        todosAnimais = todosAnimais
            .where((animal) => animal.tipo == tipo)
            .toList();
      }

      if (cidade != null && cidade != 'Todas') {
        todosAnimais = todosAnimais
            .where((animal) => animal.cidade == cidade)
            .toList();
      }

      if (donoId != null) {
        todosAnimais = todosAnimais
            .where((animal) => animal.donoId == donoId)
            .toList();
      }

      // Filtrar apenas animais ativos
      todosAnimais = todosAnimais.where((animal) => animal.ativo).toList();

      return todosAnimais;
    } catch (e) {
      print('Erro no AnimalService.buscarAnimais: $e');
      return [];
    }
  }

  // Buscar animal por ID
  static Future<Animal?> buscarAnimalPorId(String id) async {
    try {
      final animais = await _carregarAnimais();
      return animais.firstWhere(
        (animal) => animal.id == id && animal.ativo,
        orElse: () => Animal(
          nome: '',
          descricao: '',
          raca: '',
          cor: '',
          especie: '',
          sexo: '',
          imagens: [],
          cidade: '',
          bairro: '',
          donoId: '',
        ),
      );
    } catch (e) {
      print('Erro no AnimalService.buscarAnimalPorId: $e');
      return null;
    }
  }

  // Cadastrar novo animal
  static Future<Animal> cadastrarAnimal(Animal animal) async {
    try {
      final animais = await _carregarAnimais();

      // Verificar se já existe um animal com o mesmo ID
      final animalExistente = animais.any((a) => a.id == animal.id);
      if (animalExistente) {
        throw Exception('Já existe um animal com este ID');
      }

      // Adicionar o novo animal
      animais.add(animal);

      // Salvar a lista atualizada
      await _salvarAnimais(animais);

      return animal;
    } catch (e) {
      print('Erro no AnimalService.cadastrarAnimal: $e');
      throw Exception('Erro ao cadastrar animal: $e');
    }
  }

  // Atualizar animal
  static Future<Animal> atualizarAnimal(Animal animalAtualizado) async {
    try {
      final animais = await _carregarAnimais();

      // Encontrar o índice do animal
      final index = animais.indexWhere(
        (animal) => animal.id == animalAtualizado.id,
      );

      if (index == -1) {
        throw Exception('Animal não encontrado');
      }

      // Atualizar o animal
      animais[index] = animalAtualizado.copyWith(
        dataAtualizacao: DateTime.now(),
      );

      // Salvar a lista atualizada
      await _salvarAnimais(animais);

      return animais[index];
    } catch (e) {
      print('Erro no AnimalService.atualizarAnimal: $e');
      throw Exception('Erro ao atualizar animal: $e');
    }
  }

  // Excluir animal (marcar como inativo)
  static Future<bool> excluirAnimal(String id) async {
    try {
      final animais = await _carregarAnimais();

      // Encontrar o índice do animal
      final index = animais.indexWhere((animal) => animal.id == id);

      if (index == -1) {
        return false;
      }

      // Marcar como inativo em vez de remover
      animais[index] = animais[index].copyWith(
        ativo: false,
        dataAtualizacao: DateTime.now(),
      );

      // Salvar a lista atualizada
      await _salvarAnimais(animais);

      return true;
    } catch (e) {
      print('Erro no AnimalService.excluirAnimal: $e');
      return false;
    }
  }

  // Buscar animais do usuário logado
  static Future<List<Animal>> meusAnimais(String donoId) async {
    try {
      return await buscarAnimais(donoId: donoId);
    } catch (e) {
      print('Erro no AnimalService.meusAnimais: $e');
      return [];
    }
  }

  // Buscar animais por tipo (perdidos ou encontrados)
  static Future<List<Animal>> buscarAnimaisPorTipo(String tipo) async {
    try {
      return await buscarAnimais(tipo: tipo);
    } catch (e) {
      print('Erro no AnimalService.buscarAnimaisPorTipo: $e');
      return [];
    }
  }

  // Limpar todos os dados (apenas para desenvolvimento)
  static Future<void> limparTodosDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Erro ao limpar dados: $e');
    }
  }

  // Carregar dados iniciais (exemplos) se não houver dados salvos
  static Future<void> carregarDadosIniciais() async {
    try {
      final animais = await _carregarAnimais();
      if (animais.isEmpty) {
        await _salvarAnimais(Animal.exemplos);
      }
    } catch (e) {
      print('Erro ao carregar dados iniciais: $e');
    }
  }

  // Estatísticas gerais
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
      print('Erro ao obter estatísticas: $e');
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

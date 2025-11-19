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
       dataAtualizacao = dataAtualizacao ?? DateTime.now();

  // Getters
  String get imagemPrincipal =>
      imagens.isNotEmpty ? imagens[0] : "assets/cachorro1.png";

  bool get isPerdido => tipo == 'perdido';
  bool get isEncontrado => tipo == 'encontrado';

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

  // Métodos de cópia e conversão
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
    return 'Animal(id: $id, nome: $nome, tipo: $tipo, donoId: $donoId)';
  }
}

// Serviço para gerenciar animais usando API
class AnimalService {
  // Buscar todos os animais
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
    String? donoId,
  }) async {
    return await AnimalApiService.buscarAnimais(
      tipo: tipo,
      cidade: cidade,
      donoId: donoId,
    );
  }

  // Buscar animal por ID
  static Future<Animal?> buscarAnimalPorId(String id) async {
    return await AnimalApiService.buscarAnimalPorId(id);
  }

  // Cadastrar novo animal
  static Future<Animal> cadastrarAnimal(Animal animal) async {
    return await AnimalApiService.cadastrarAnimal(animal);
  }

  // Atualizar animal
  static Future<Animal> atualizarAnimal(Animal animal) async {
    return await AnimalApiService.atualizarAnimal(animal);
  }

  // Excluir animal
  static Future<bool> excluirAnimal(String id) async {
    return await AnimalApiService.excluirAnimal(id);
  }

  // Buscar animais do usuário
  static Future<List<Animal>> meusAnimais(String donoId) async {
    return await AnimalApiService.meusAnimais(donoId);
  }

  // Buscar animais por tipo
  static Future<List<Animal>> buscarAnimaisPorTipo(String tipo) async {
    return await AnimalApiService.buscarAnimaisPorTipo(tipo);
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

  // Método vazio para compatibilidade (não faz nada com API)
  static Future<void> carregarDadosIniciais() async {
    // Não faz nada na versão com API
  }
}

import 'dart:convert';
import 'animal.dart';
import 'api_service.dart';

class AnimalApiService {
  // ================================
  //   FLUTTER → LARAVEL
  // ================================
  static Map<String, dynamic> _animalToMap(Animal animal) {
    return {
      'nome': animal.nome,
      'descricao': animal.descricao,
      'raca': animal.raca,
      'cor': animal.cor,
      'especie': animal.especie,
      'sexo': animal.sexo,
      'cidade': animal.cidade,
      'bairro': animal.bairro,

      // sua migration usa ENUM('perdido','encontrado')
      'situacao': animal.tipo,

      // JSON de imagens
      'imagens': animal.imagens,

      // campos para animais perdidos
      'ultimo_local_visto': animal.ultimoLocalVisto,
      'endereco_desaparecimento': animal.enderecoDesaparecimento,
      'data_desaparecimento': animal.dataDesaparecimento,

      // campos de dono
      'user_id': animal.donoId,

      // status ENUM
      'status': animal.ativo ? 'ativo' : 'arquivado',

      // soft delete manual
      'ativo': animal.ativo,
    };
  }

  // ================================
  //   LARAVEL → FLUTTER
  // ================================
  static Animal _mapToAnimal(Map<String, dynamic> map) {
    return Animal(
      id: map['id'].toString(),
      nome: map['nome'] ?? '(sem nome)',
      descricao: map['descricao'] ?? '',
      raca: map['raca'] ?? '',
      cor: map['cor'] ?? '',
      especie: map['especie'] ?? '',
      sexo: map['sexo'] ?? '',
      cidade: map['cidade'] ?? '',
      bairro: map['bairro'] ?? '',
      donoId: map['user_id'].toString(),

      imagens: _parseImagens(map),

      dataCriacao: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,

      dataAtualizacao: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'])
          : null,

      ativo: map['ativo'] == true,

      // situação → tipo
      tipo: map['situacao'] ?? 'perdido',

      ultimoLocalVisto: map['ultimo_local_visto'],
      enderecoDesaparecimento: map['endereco_desaparecimento'],
      dataDesaparecimento: map['data_desaparecimento'],
    );
  }

  // ================================
  //     IMAGENS
  // ================================
  static List<String> _parseImagens(Map<String, dynamic> map) {
    if (map['imagens'] == null) return ['assets/cachorro1.png'];

    try {
      if (map['imagens'] is List) {
        return List<String>.from(map['imagens']);
      }

      if (map['imagens'] is String) {
        return List<String>.from(json.decode(map['imagens']));
      }
    } catch (_) {}

    return ['assets/cachorro1.png'];
  }

  // ================================
  //   CRUD
  // ================================
  static Future<List<Animal>> buscarAnimais({
    String? tipo,
    String? cidade,
    String? donoId,
  }) async {
    final params = <String, String>{};

    if (tipo != null) params['situacao'] = tipo;
    if (cidade != null && cidade != 'Todas') params['cidade'] = cidade;
    if (donoId != null) params['user_id'] = donoId;

    String endpoint = 'animais';
    if (params.isNotEmpty) {
      endpoint += '?${Uri(queryParameters: params).query}';
    }

    final response = await ApiService.get(endpoint);
    final data = json.decode(response.body);

    List list;
    if (data is List) {
      list = data;
    } else if (data is Map && data.containsKey('data')) {
      list = data['data'];
    } else {
      return [];
    }

    return list.map((item) => _mapToAnimal(item)).toList();
  }

  static Future<Animal?> buscarAnimalPorId(String id) async {
    final response = await ApiService.get('animais/$id');
    final data = json.decode(response.body);
    return _mapToAnimal(data);
  }

  static Future<Animal> cadastrarAnimal(Animal animal) async {
    final response = await ApiService.post('animais', _animalToMap(animal));

    return _mapToAnimal(json.decode(response.body));
  }

  static Future<Animal> atualizarAnimal(Animal animal) async {
    final response = await ApiService.put(
      'animais/${animal.id}',
      _animalToMap(animal),
    );

    return _mapToAnimal(json.decode(response.body));
  }

  static Future<bool> excluirAnimal(String id) async {
    await ApiService.delete('animais/$id');
    return true;
  }

  static Future<List<Animal>> meusAnimais(String donoId) async {
    return await buscarAnimais(donoId: donoId);
  }

  static Future<List<Animal>> buscarAnimaisPorTipo(String tipo) async {
    return await buscarAnimais(tipo: tipo);
  }
}

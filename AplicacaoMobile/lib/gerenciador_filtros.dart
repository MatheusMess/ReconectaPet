// gerenciador_filtros.dart
import 'package:flutter/material.dart';
import 'animal.dart';

class GerenciadorFiltros with ChangeNotifier {
  // Estados dos filtros
  String _filtroTipo = 'Todos';
  String _filtroEspecie = 'Todos';
  String _filtroCidade = 'Todas';
  String _filtroRaca = 'Todas';
  List<String> _filtroCores = []; // ✅ AGORA É UMA LISTA!

  // Listas para os dropdowns
  List<String> cidades = ['Todas'];
  List<String> racas = ['Todas'];
  List<String> coresDisponiveis = []; // ✅ TODAS AS CORES DISPONÍVEIS

  // Getters
  String get filtroTipo => _filtroTipo;
  String get filtroEspecie => _filtroEspecie;
  String get filtroCidade => _filtroCidade;
  String get filtroRaca => _filtroRaca;
  List<String> get filtroCores => _filtroCores; // ✅ AGORA RETORNA LISTA

  // Setters que notificam listeners
  set filtroTipo(String value) {
    _filtroTipo = value;
    notifyListeners();
  }

  set filtroEspecie(String value) {
    _filtroEspecie = value;
    notifyListeners();
  }

  set filtroCidade(String value) {
    _filtroCidade = value;
    notifyListeners();
  }

  set filtroRaca(String value) {
    _filtroRaca = value;
    notifyListeners();
  }

  // ✅ MÉTODOS PARA MANIPULAR MÚLTIPLAS CORES
  void adicionarCor(String cor) {
    if (!_filtroCores.contains(cor)) {
      _filtroCores.add(cor);
      notifyListeners();
    }
  }

  void removerCor(String cor) {
    _filtroCores.remove(cor);
    notifyListeners();
  }

  void limparCores() {
    _filtroCores.clear();
    notifyListeners();
  }

  bool get temCoresSelecionadas => _filtroCores.isNotEmpty;

  // ✅ CORREÇÃO: Método para extrair cores individuais
  List<String> _extrairCoresIndividuais(List<Animal> animais) {
    final todasCores = <String>{};

    for (var animal in animais) {
      if (animal.cor.isNotEmpty) {
        // Quebra por vírgula e espaço, remove espaços extras
        final coresAnimal = animal.cor
            .split(RegExp(r'[, ]+'))
            .where((cor) => cor.trim().isNotEmpty)
            .map((cor) => cor.trim())
            .toList();

        todasCores.addAll(coresAnimal);
      }
    }

    return todasCores.toList()..sort();
  }

  // Carregar opções de filtro
  void carregarFiltros(List<Animal> animais) {
    final todosAnimais = animais;

    // Cidades
    cidades = ['Todas'];
    cidades.addAll(
      todosAnimais
          .map((animal) => animal.cidade)
          .where((cidade) => cidade.isNotEmpty)
          .toSet()
          .toList()
        ..sort(),
    );

    // Raças
    racas = ['Todas'];
    racas.addAll(
      todosAnimais
          .map((animal) => animal.raca)
          .where((raca) => raca.isNotEmpty)
          .toSet()
          .toList()
        ..sort(),
    );

    // ✅ CORES INDIVIDUAIS
    coresDisponiveis = _extrairCoresIndividuais(todosAnimais);

    notifyListeners();
  }

  // Aplicar filtros
  List<Animal> aplicarFiltros(List<Animal> animais) {
    List<Animal> listaFiltrada = [...animais];

    // Filtro por tipo
    if (_filtroTipo != 'Todos') {
      listaFiltrada = listaFiltrada.where((animal) {
        return _filtroTipo == 'Perdidos'
            ? animal.isPerdido
            : animal.isEncontrado;
      }).toList();
    }

    // Filtro por espécie
    if (_filtroEspecie != 'Todos') {
      listaFiltrada = listaFiltrada.where((animal) {
        return animal.especie.toLowerCase() == _filtroEspecie.toLowerCase();
      }).toList();
    }

    // Filtro por cidade
    if (_filtroCidade != 'Todas') {
      listaFiltrada = listaFiltrada.where((animal) {
        return animal.cidade == _filtroCidade;
      }).toList();
    }

    // Filtro por raça
    if (_filtroRaca != 'Todas') {
      listaFiltrada = listaFiltrada.where((animal) {
        return animal.raca == _filtroRaca;
      }).toList();
    }

    // ✅ FILTRO POR MÚLTIPLAS CORES
    if (_filtroCores.isNotEmpty) {
      listaFiltrada = listaFiltrada.where((animal) {
        if (animal.cor.isEmpty) return false;

        // Quebra a cor do animal em cores individuais
        final coresAnimal = animal.cor
            .split(RegExp(r'[, ]+'))
            .where((cor) => cor.trim().isNotEmpty)
            .map((cor) => cor.trim())
            .toList();

        // Verifica se o animal tem PELO MENOS UMA das cores selecionadas
        return coresAnimal.any(
          (corAnimal) => _filtroCores.any(
            (corFiltro) => corAnimal.toLowerCase() == corFiltro.toLowerCase(),
          ),
        );
      }).toList();
    }

    return listaFiltrada;
  }

  // Limpar todos os filtros
  void limparFiltros() {
    _filtroTipo = 'Todos';
    _filtroEspecie = 'Todos';
    _filtroCidade = 'Todas';
    _filtroRaca = 'Todas';
    _filtroCores.clear(); // ✅ LIMPA A LISTA DE CORES
    notifyListeners();
  }

  // Remover filtro específico
  void removerFiltro(String tipo) {
    switch (tipo) {
      case 'Tipo':
        _filtroTipo = 'Todos';
        break;
      case 'Espécie':
        _filtroEspecie = 'Todos';
        break;
      case 'Cidade':
        _filtroCidade = 'Todas';
        break;
      case 'Raça':
        _filtroRaca = 'Todas';
        break;
      case 'Cor':
        _filtroCores.clear(); // ✅ LIMPA TODAS AS CORES
        break;
    }
    notifyListeners();
  }

  // Verificar se há filtros ativos
  bool get temFiltrosAtivos {
    return _filtroTipo != 'Todos' ||
        _filtroEspecie != 'Todos' ||
        _filtroCidade != 'Todas' ||
        _filtroRaca != 'Todas' ||
        _filtroCores.isNotEmpty; // ✅ VERIFICA SE TEM CORES SELECIONADAS
  }

  // Obter lista de filtros ativos para chips
  List<Map<String, dynamic>> get filtrosAtivos {
    final List<Map<String, dynamic>> ativos = [];

    if (_filtroTipo != 'Todos') {
      ativos.add({'tipo': 'Tipo', 'valor': _filtroTipo, 'cor': Colors.blue});
    }
    if (_filtroEspecie != 'Todos') {
      ativos.add({
        'tipo': 'Espécie',
        'valor': _filtroEspecie,
        'cor': Colors.green,
      });
    }
    if (_filtroCidade != 'Todas') {
      ativos.add({
        'tipo': 'Cidade',
        'valor': _filtroCidade,
        'cor': Colors.orange,
      });
    }
    if (_filtroRaca != 'Todas') {
      ativos.add({'tipo': 'Raça', 'valor': _filtroRaca, 'cor': Colors.purple});
    }

    // ✅ CHIPS INDIVIDUAIS PARA CADA COR SELECIONADA
    for (var cor in _filtroCores) {
      ativos.add({'tipo': 'Cor', 'valor': cor, 'cor': Colors.red});
    }

    return ativos;
  }

  // ✅ WIDGET DO MODAL DE FILTROS - AGORA COM MULTISELECT DE CORES
  static Widget criarModalFiltros({
    required BuildContext context,
    required GerenciadorFiltros gerenciador,
    required VoidCallback onAplicarFiltros,
    required int totalAnimais,
  }) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filtrar Animais",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        gerenciador.limparFiltros();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Limpar",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Conteúdo dos filtros
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ListenableBuilder(
                listenable: gerenciador,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFiltroSection(
                        "Tipo de Animal",
                        _buildDropdownFiltro(
                          value: gerenciador.filtroTipo,
                          items: const ['Todos', 'Perdidos', 'Encontrados'],
                          onChanged: (value) {
                            gerenciador.filtroTipo = value!;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildFiltroSection(
                        "Espécie",
                        _buildDropdownFiltro(
                          value: gerenciador.filtroEspecie,
                          items: const ['Todos', 'Cachorro', 'Gato'],
                          onChanged: (value) {
                            gerenciador.filtroEspecie = value!;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildFiltroSection(
                        "Cidade",
                        _buildDropdownFiltro(
                          value: gerenciador.filtroCidade,
                          items: gerenciador.cidades,
                          onChanged: (value) {
                            gerenciador.filtroCidade = value!;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildFiltroSection(
                        "Raça",
                        _buildDropdownFiltro(
                          value: gerenciador.filtroRaca,
                          items: gerenciador.racas,
                          onChanged: (value) {
                            gerenciador.filtroRaca = value!;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ SEÇÃO DE CORES COM MULTISELECT
                      _buildFiltroSection(
                        "Cores",
                        _buildCoresMultiSelect(gerenciador),
                      ),

                      const SizedBox(height: 30),

                      // Resultados da busca
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Resultados da Busca",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.cyan,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${gerenciador.filtrosAtivos.length} filtro(s) ativo(s)",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            if (gerenciador.temCoresSelecionadas) ...[
                              const SizedBox(height: 8),
                              Text(
                                "${gerenciador.filtroCores.length} cor(es) selecionada(s)",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botão aplicar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            onAplicarFiltros();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "APLICAR FILTROS",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NOVO WIDGET PARA MULTISELECT DE CORES
  static Widget _buildCoresMultiSelect(GerenciadorFiltros gerenciador) {
    return Column(
      children: [
        // Grid de cores
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: gerenciador.coresDisponiveis.map((cor) {
            final bool selecionada = gerenciador.filtroCores.contains(cor);

            return FilterChip(
              label: Text(
                cor,
                style: TextStyle(
                  color: selecionada ? Colors.white : Colors.black,
                ),
              ),
              selected: selecionada,
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.red,
              checkmarkColor: Colors.white,
              onSelected: (selecionar) {
                if (selecionar) {
                  gerenciador.adicionarCor(cor);
                } else {
                  gerenciador.removerCor(cor);
                }
              },
            );
          }).toList(),
        ),

        // Botão limpar cores
        if (gerenciador.temCoresSelecionadas) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: gerenciador.limparCores,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text("Limpar Cores Selecionadas"),
            ),
          ),
        ],
      ],
    );
  }

  // Métodos auxiliares para construir a UI
  static Widget _buildFiltroSection(String titulo, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.cyan,
          ),
        ),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  static Widget _buildDropdownFiltro({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';
import 'navegacao.dart';
import 'autenticacao.dart';
import 'tela_cadastro_animal_encontrado.dart';
import 'tela_editar_animal.dart';
import 'gerenciador_filtros.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final List<Animal> animaisPerdidos = [];
  final List<Animal> animaisEncontrados = [];
  int _indiceSelecionado = 0;
  final AuthService _authService = AuthService();
  bool _carregando = true;

  // ✅ GERENCIADOR DE FILTROS
  final GerenciadorFiltros gerenciadorFiltros = GerenciadorFiltros();

  @override
  void initState() {
    super.initState();
    _carregarAnimais();
  }

  void _carregarAnimais() async {
    setState(() {
      _carregando = true;
    });

    try {
      final todosAnimais = await AnimalService.buscarAnimais();

      setState(() {
        animaisPerdidos.clear();
        animaisEncontrados.clear();

        for (var animal in todosAnimais) {
          if (animal.isPerdido) {
            animaisPerdidos.add(animal);
          } else {
            animaisEncontrados.add(animal);
          }
        }

        // ✅ CARREGAR FILTROS
        gerenciadorFiltros.carregarFiltros([
          ...animaisPerdidos,
          ...animaisEncontrados,
        ]);
        _carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar animais: $e');
      setState(() {
        _carregando = false;
      });
      _mostrarMensagem('Erro ao carregar animais: $e');
    }
  }

  void _atualizarTela() {
    _carregarAnimais();
  }

  Future<void> adicionarAnimal(Animal animal) async {
    try {
      final usuario = _authService.usuarioLogado;
      final animalComDono = animal.copyWith(
        donoId: usuario?.id ?? 'usuario_desconhecido',
        userNome: usuario?.nome,
        userTelefone: usuario?.telefone,
        userEmail: usuario?.email,
      );

      await AnimalService.cadastrarAnimal(animalComDono);
      _atualizarTela();
      _mostrarMensagem('${animal.nome} cadastrado com sucesso!');
    } catch (e) {
      _mostrarMensagem('Erro ao cadastrar animal: $e');
    }
  }

  Future<void> _editarAnimal(Animal animal) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaEditarAnimal(animal: animal)),
    );

    if (resultado == true) {
      _atualizarTela();
      _mostrarMensagem('Animal atualizado com sucesso!');
    }
  }

  // ✅ MÉTODO SIMPLIFICADO - USA GERENCIADOR DE FILTROS
  List<Animal> _getAnimaisFiltrados() {
    final todosAnimais = [...animaisPerdidos, ...animaisEncontrados];
    return gerenciadorFiltros.aplicarFiltros(todosAnimais);
  }

  // ✅ MODAL DE FILTROS SIMPLIFICADO
  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GerenciadorFiltros.criarModalFiltros(
        context: context,
        gerenciador: gerenciadorFiltros,
        onAplicarFiltros: () {
          setState(() {}); // Atualiza a UI
        },
        totalAnimais: animaisPerdidos.length + animaisEncontrados.length,
      ),
    );
  }

  void mostrarPopupCadastro() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Wrap(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Cadastrar Animal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pets, color: Colors.cyan),
              title: const Text("Animal Perdido"),
              subtitle: const Text("Cadastre um animal que desapareceu"),
              onTap: () {
                Navigator.pop(context);
                Navegacao.irParaCadastroAnimalPerdido(context, adicionarAnimal);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.search, color: Colors.orange),
              title: const Text("Animal Encontrado"),
              subtitle: const Text("Cadastre um animal que foi encontrado"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TelaCadastroAnimalEncontrado(onSalvar: adicionarAnimal),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _construirListaAnimais() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    final animaisFiltrados = _getAnimaisFiltrados();

    if (animaisFiltrados.isEmpty) {
      return Column(
        children: [
          _buildHeaderFiltros(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _atualizarTela();
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Nenhum animal encontrado",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Tente ajustar os filtros ou cadastrar um novo animal",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: mostrarPopupCadastro,
                          icon: const Icon(Icons.add),
                          label: const Text("Cadastrar Animal"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildHeaderFiltros(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              _atualizarTela();
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              itemCount: animaisFiltrados.length,
              itemBuilder: (context, index) {
                final animal = animaisFiltrados[index];
                return _buildAnimalCard(animal, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimalCard(Animal animal, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navegacao.irParaDetalhesAnimal(context, animal);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _construirImagemAnimal(animal),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: animal.isPerdido
                              ? Colors.red.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: animal.isPerdido ? Colors.red : Colors.green,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          animal.isPerdido ? 'PERDIDO' : 'ENCONTRADO',
                          style: TextStyle(
                            fontSize: 10,
                            color: animal.isPerdido ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              animal.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getCorSexo(animal.sexo),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              animal.sexo,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Text(
                        '${animal.especie} • ${animal.raca}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          animal.cor,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.cyan,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              animal.localizacaoCompleta,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            animal.isPerdido
                                ? 'Desaparecido em: ${animal.dataDisplay}'
                                : 'Encontrado em: ${animal.dataDisplay}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ HEADER DE FILTROS SIMPLIFICADO
  Widget _buildHeaderFiltros() {
    if (!gerenciadorFiltros.temFiltrosAtivos) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, size: 18, color: Colors.cyan),
              const SizedBox(width: 8),
              const Text(
                "Filtros Ativos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: gerenciadorFiltros.filtrosAtivos.map((filtro) {
              return Chip(
                label: Text(
                  "${filtro['tipo']}: ${filtro['valor']}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: filtro['cor'],
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
                onDeleted: () {
                  gerenciadorFiltros.removerFiltro(filtro['tipo']);
                  setState(() {});
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODO CORRIGIDO PARA IMAGENS
  Widget _construirImagemAnimal(Animal animal) {
    if (animal.imagens.isNotEmpty) {
      final primeiraImagem = animal.imagens[0];

      if (primeiraImagem.startsWith('http')) {
        // ✅ IMAGENS DA INTERNET (Laravel)
        return Image.network(
          primeiraImagem,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _construirPlaceholderImagem();
          },
        );
      } else if (primeiraImagem.startsWith('assets/')) {
        // ✅ IMAGENS LOCAIS (assets)
        return Image.asset(
          primeiraImagem,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _construirPlaceholderImagem();
          },
        );
      } else {
        // ✅ ARQUIVOS LOCAIS (File)
        return Image.file(
          File(primeiraImagem),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _construirPlaceholderImagem();
          },
        );
      }
    }
    return _construirPlaceholderImagem();
  }

  Widget _construirPlaceholderImagem() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.pets, color: Colors.grey, size: 40),
    );
  }

  Color _getCorSexo(String sexo) {
    switch (sexo.toLowerCase()) {
      case 'macho':
        return Colors.blue;
      case 'fêmea':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _confirmarRemocaoAnimal(Animal animal) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remover Animal"),
        content: Text("Tem certeza que deseja remover ${animal.nome}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await AnimalService.excluirAnimal(animal.id);
                _atualizarTela();
                _mostrarMensagem('${animal.nome} removido com sucesso');
              } catch (e) {
                _mostrarMensagem('Erro ao remover animal: $e');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Remover"),
          ),
        ],
      ),
    );
  }

  Widget _construirTelaPerfil() {
    final usuario = _authService.usuarioLogado;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              usuario?.nome ?? "Usuário",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              usuario?.email ?? "email@exemplo.com",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informações Pessoais",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _infoPerfil(
                      "Telefone",
                      usuario?.telefone ?? "Não informado",
                      Icons.phone,
                    ),
                    const SizedBox(height: 12),
                    _infoPerfil(
                      "CPF",
                      usuario?.cpf ?? "Não informado",
                      Icons.credit_card,
                    ),
                    const SizedBox(height: 12),
                    _infoPerfil(
                      "Membro desde",
                      usuario?.dataCriacao != null
                          ? "${usuario!.dataCriacao!.day}/${usuario.dataCriacao!.month}/${usuario.dataCriacao!.year}"
                          : "Outubro 2024",
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text("Editar Perfil"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navegacao.irParaEditarPerfil(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.work_history,
                      color: Colors.purple,
                    ),
                    title: const Text("Meus Casos"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _mostrarMeusCasos,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _confirmarLogout(context);
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Sair da Conta"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoPerfil(String titulo, String valor, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: Colors.cyan, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ CORRIGIDO: "Meus Casos" agora filtra apenas os animais do usuário logado
  void _mostrarMeusCasos() async {
    final usuario = _authService.usuarioLogado;
    if (usuario == null) {
      _mostrarMensagem('Usuário não logado');
      return;
    }

    try {
      // ✅ CORREÇÃO: Busca apenas os animais do usuário logado
      final meusAnimais = await AnimalService.meusAnimais(usuario.id);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.work_history, color: Colors.purple),
              SizedBox(width: 8),
              Text("Meus Casos"),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: meusAnimais.isEmpty
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cases_outlined, size: 60, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Nenhum caso cadastrado",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Cadastre seu primeiro animal na tela inicial",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Toque em um animal para editá-lo",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 12),
                      ...meusAnimais
                          .map(
                            (animal) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[100],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: _construirImagemAnimal(animal),
                                  ),
                                ),
                                title: Text(
                                  animal.nome,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${animal.especie} • ${animal.raca}'),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: animal.isPerdido
                                            ? Colors.orange.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: animal.isPerdido
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                      ),
                                      child: Text(
                                        animal.isPerdido
                                            ? 'PERDIDO'
                                            : 'ENCONTRADO',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: animal.isPerdido
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _confirmarRemocaoAnimal(animal);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _editarAnimal(animal);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fechar"),
            ),
            if (meusAnimais.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _indiceSelecionado = 0;
                  });
                },
                child: const Text("Ver Todos"),
              ),
          ],
        ),
      );
    } catch (e) {
      _mostrarMensagem('Erro ao carregar meus casos: $e');
    }
  }

  Widget _construirTelaSobre() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.cyan,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.pets, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "ReconectaPet",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Conectando animais perdidos com suas famílias",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Estatísticas do App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<Map<String, int>>(
                      future: AnimalService.obterEstatisticas(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final stats =
                            snapshot.data ??
                            {
                              'total': 0,
                              'perdidos': 0,
                              'encontrados': 0,
                              'cachorros': 0,
                              'gatos': 0,
                              'recentes': 0,
                            };

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _construirEstatistica(
                                  "Total",
                                  stats['total']!,
                                  Icons.pets,
                                ),
                                _construirEstatistica(
                                  "Perdidos",
                                  stats['perdidos']!,
                                  Icons.warning_amber,
                                  cor: Colors.orange,
                                ),
                                _construirEstatistica(
                                  "Encontrados",
                                  stats['encontrados']!,
                                  Icons.search,
                                  cor: Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _construirEstatistica(
                                  "Cachorros",
                                  stats['cachorros']!,
                                  Icons.pets,
                                  cor: Colors.brown,
                                ),
                                _construirEstatistica(
                                  "Gatos",
                                  stats['gatos']!,
                                  Icons.pets,
                                  cor: Colors.grey,
                                ),
                                _construirEstatistica(
                                  "Recentes",
                                  stats['recentes']!,
                                  Icons.new_releases,
                                  cor: Colors.purple,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sobre o ReconectaPet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "O ReconectaPet é um aplicativo dedicado a ajudar famílias a reencontrar seus animais de estimação perdidos. Nossa missão é conectar animais desaparecidos com seus tutores através de uma plataforma simples e eficiente.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoApp("Versão", "1.0.0", Icons.info),
                    _infoApp("Desenvolvido com", "Flutter", Icons.code),
                    _infoApp("Última atualização", "Out 2024", Icons.update),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoApp(String titulo, String valor, IconData icone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icone, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$titulo: ",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          Text(valor, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _construirEstatistica(
    String titulo,
    int quantidade,
    IconData icone, {
    Color? cor,
  }) {
    final corFinal = cor ?? Colors.cyan;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: corFinal.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icone, color: corFinal, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          quantidade.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: corFinal,
          ),
        ),
        Text(
          titulo,
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ✅ CORRIGIDO: Logout agora limpa tudo corretamente
  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sair da Conta"),
        content: const Text("Tem certeza que deseja sair?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navegacao.fazerLogout(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Sair"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ReconectaPet",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        elevation: 0,
        actions: [
          if (_indiceSelecionado == 0) ...[
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: "Filtros",
              onPressed: _mostrarFiltros,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Cadastrar Animal",
              onPressed: mostrarPopupCadastro,
            ),
          ],
        ],
      ),
      body: _getTelaPorIndice(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelecionado,
        onTap: (index) {
          setState(() {
            _indiceSelecionado = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
        ],
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _indiceSelecionado == 0
          ? FloatingActionButton(
              onPressed: mostrarPopupCadastro,
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _getTelaPorIndice() {
    switch (_indiceSelecionado) {
      case 0:
        return _construirListaAnimais();
      case 1:
        return _construirTelaPerfil();
      case 2:
        return _construirTelaSobre();
      default:
        return _construirListaAnimais();
    }
  }
}

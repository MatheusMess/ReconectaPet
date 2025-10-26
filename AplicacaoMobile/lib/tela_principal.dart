import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';
import 'navegacao.dart';
import 'autenticacao.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final List<Animal> animaisPerdidos = [];
  int _indiceSelecionado = 0;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _carregarAnimaisExemplo();
  }

  void _carregarAnimaisExemplo() {
    setState(() {
      animaisPerdidos.addAll(Animal.exemplos);
    });
  }

  void adicionarAnimal(Animal animal) {
    setState(() {
      animaisPerdidos.add(animal);
    });
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
                // USANDO NAVEGAÇÃO EM VEZ DE Navigator.push
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
                _mostrarMensagem('Funcionalidade em desenvolvimento');
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
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _construirListaAnimais() {
    if (animaisPerdidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Nenhum animal cadastrado",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Toque no botão + para adicionar",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: mostrarPopupCadastro,
              icon: const Icon(Icons.add),
              label: const Text("Cadastrar Primeiro Animal"),
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
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        itemCount: animaisPerdidos.length,
        itemBuilder: (context, index) {
          final animal = animaisPerdidos[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // USANDO NAVEGAÇÃO EM VEZ DE Navigator.push
                  Navegacao.irParaDetalhesAnimal(context, animal);
                },
                onLongPress: () {
                  _mostrarOpcoesAnimal(context, index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGEM GRANDE
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
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

                      // INFORMAÇÕES
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // NOME E SEXO
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

                            // ESPÉCIE E RAÇA
                            Text(
                              '${animal.especie} • ${animal.raca}',
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // COR
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

                            // LOCALIZAÇÃO
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
                                    '${animal.bairro}, ${animal.cidade}',
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

                            // DATA
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Desaparecido em: ${animal.dataDesaparecimento}',
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

                      // SETA
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirImagemAnimal(Animal animal) {
    if (animal.imagens.isNotEmpty) {
      final primeiraImagem = animal.imagens[0];
      if (primeiraImagem.startsWith('assets/')) {
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

  void _mostrarOpcoesAnimal(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.visibility, color: Colors.blue),
            title: const Text("Ver Detalhes"),
            onTap: () {
              Navigator.pop(context);
              Navegacao.irParaDetalhesAnimal(context, animaisPerdidos[index]);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.green),
            title: const Text("Compartilhar"),
            onTap: () {
              Navigator.pop(context);
              _mostrarMensagem('Compartilhamento em desenvolvimento');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Remover Animal"),
            onTap: () {
              Navigator.pop(context);
              _confirmarRemocaoAnimal(index);
            },
          ),
        ],
      ),
    );
  }

  void _confirmarRemocaoAnimal(int index) {
    final animal = animaisPerdidos[index];
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
            onPressed: () {
              setState(() {
                animaisPerdidos.removeAt(index);
              });
              Navigator.pop(context);
              _mostrarMensagem('${animal.nome} removido com sucesso');
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

            // Informações Pessoais
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
                      "Outubro 2024",
                      Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Configurações
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
                      Icons.notifications,
                      color: Colors.orange,
                    ),
                    title: const Text("Notificações"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navegacao.irParaConfiguracoesNotificacao(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.green),
                    title: const Text("Privacidade e Segurança"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _mostrarMensagem(
                        'Configurações de privacidade em desenvolvimento',
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Botão Sair
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

  Widget _construirTelaSobre() {
    final animaisCachorro = animaisPerdidos
        .where((animal) => animal.especie.toLowerCase() == 'cachorro')
        .length;
    final animaisGato = animaisPerdidos
        .where((animal) => animal.especie.toLowerCase() == 'gato')
        .length;
    final outrosAnimais =
        animaisPerdidos.length - animaisCachorro - animaisGato;

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

            // Estatísticas
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _construirEstatistica(
                          "Total",
                          animaisPerdidos.length,
                          Icons.pets,
                        ),
                        _construirEstatistica(
                          "Cachorros",
                          animaisCachorro,
                          Icons.pets,
                        ),
                        _construirEstatistica("Gatos", animaisGato, Icons.pets),
                        _construirEstatistica(
                          "Outros",
                          outrosAnimais,
                          Icons.pets,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informações detalhadas
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: const Text("Animais por Localização"),
                subtitle: Text(
                  "${_contarAnimaisUnicosPorCidade()} cidades diferentes",
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _mostrarAnimaisPorLocalizacao();
                },
              ),
            ),

            const SizedBox(height: 16),

            // Sobre o App
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

            const SizedBox(height: 16),

            // Ajuda e Suporte
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help, color: Colors.orange),
                    title: const Text("Ajuda e Suporte"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navegacao.irParaAjuda(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.green),
                    title: const Text("Política de Privacidade"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _mostrarMensagem(
                        'Política de privacidade em desenvolvimento',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.article, color: Colors.purple),
                    title: const Text("Termos de Uso"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _mostrarMensagem('Termos de uso em desenvolvimento');
                    },
                  ),
                ],
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

  Widget _construirEstatistica(String titulo, int quantidade, IconData icone) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.cyan.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icone, color: Colors.cyan, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          quantidade.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.cyan,
          ),
        ),
        Text(titulo, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ],
    );
  }

  int _contarAnimaisUnicosPorCidade() {
    final cidades = animaisPerdidos.map((animal) => animal.cidade).toSet();
    return cidades.length;
  }

  void _mostrarAnimaisPorLocalizacao() {
    final animaisPorCidade = <String, List<Animal>>{};

    for (final animal in animaisPerdidos) {
      if (!animaisPorCidade.containsKey(animal.cidade)) {
        animaisPorCidade[animal.cidade] = [];
      }
      animaisPorCidade[animal.cidade]!.add(animal);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Animais por Localização"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: animaisPorCidade.length,
            itemBuilder: (context, index) {
              final cidade = animaisPorCidade.keys.elementAt(index);
              final animais = animaisPorCidade[cidade]!;
              return ListTile(
                leading: const Icon(Icons.location_city, color: Colors.cyan),
                title: Text(cidade),
                subtitle: Text('${animais.length} animal(es)'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.pop(context);
                  _mostrarAnimaisDaCidade(cidade, animais);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  void _mostrarAnimaisDaCidade(String cidade, List<Animal> animais) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Animais em $cidade"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: animais.length,
            itemBuilder: (context, index) {
              final animal = animais[index];
              return ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _construirImagemPequena(animal),
                  ),
                ),
                title: Text(animal.nome),
                subtitle: Text('${animal.raca} - ${animal.bairro}'),
                onTap: () {
                  Navigator.pop(context);
                  Navegacao.irParaDetalhesAnimal(context, animal);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Widget _construirImagemPequena(Animal animal) {
    if (animal.imagens.isNotEmpty) {
      final primeiraImagem = animal.imagens[0];
      if (primeiraImagem.startsWith('assets/')) {
        return Image.asset(
          primeiraImagem,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.pets, color: Colors.grey, size: 20),
            );
          },
        );
      } else {
        return Image.file(
          File(primeiraImagem),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(Icons.pets, color: Colors.grey, size: 20),
            );
          },
        );
      }
    }
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.pets, color: Colors.grey, size: 20),
    );
  }

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
          if (animaisPerdidos.isNotEmpty && _indiceSelecionado == 0)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: "Cadastrar Animal",
              onPressed: mostrarPopupCadastro,
            ),
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
      floatingActionButton: _indiceSelecionado == 0 && animaisPerdidos.isEmpty
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

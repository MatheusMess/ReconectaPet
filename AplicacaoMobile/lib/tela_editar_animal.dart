import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'animal.dart';

class TelaEditarAnimal extends StatefulWidget {
  final Animal animal;

  const TelaEditarAnimal({super.key, required this.animal});

  @override
  State<TelaEditarAnimal> createState() => _TelaEditarAnimalState();
}

class _TelaEditarAnimalState extends State<TelaEditarAnimal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _racaController = TextEditingController();
  final _corController = TextEditingController();
  final _especieController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _bairroController = TextEditingController();

  // Campos específicos para animais perdidos
  final _ultimoLocalVistoController = TextEditingController();
  final _enderecoDesaparecimentoController = TextEditingController();
  final _dataDesaparecimentoController = TextEditingController();

  // Campos específicos para animais encontrados
  final _localEncontroController = TextEditingController();
  final _enderecoEncontroController = TextEditingController();
  final _dataEncontroController = TextEditingController();
  final _situacaoSaudeController = TextEditingController();
  final _contatoResponsavelController = TextEditingController();

  String _sexo = 'Macho';
  String _tipo = 'perdido';
  List<String> _imagens = [];
  bool _carregando = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _carregarDadosAnimal();
  }

  void _carregarDadosAnimal() {
    final animal = widget.animal;

    _nomeController.text = animal.nome;
    _descricaoController.text = animal.descricao;
    _racaController.text = animal.raca;
    _corController.text = animal.cor;
    _especieController.text = animal.especie;
    _cidadeController.text = animal.cidade;
    _bairroController.text = animal.bairro;
    _sexo = animal.sexo;
    _tipo = animal.tipo;
    _imagens = List.from(animal.imagens);

    // Campos específicos para perdidos
    _ultimoLocalVistoController.text = animal.ultimoLocalVisto ?? '';
    _enderecoDesaparecimentoController.text =
        animal.enderecoDesaparecimento ?? '';
    _dataDesaparecimentoController.text = animal.dataDesaparecimento ?? '';

    // Campos específicos para encontrados
    _localEncontroController.text = animal.localEncontro ?? '';
    _enderecoEncontroController.text = animal.enderecoEncontro ?? '';
    _dataEncontroController.text = animal.dataEncontro ?? '';
    _situacaoSaudeController.text = animal.situacaoSaude ?? '';
    _contatoResponsavelController.text = animal.contatoResponsavel ?? '';
  }

  Future<void> _selecionarImagem() async {
    try {
      final XFile? imagem = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (imagem != null) {
        setState(() {
          _imagens.add(imagem.path);
        });
      }
    } catch (e) {
      _mostrarMensagem('Erro ao selecionar imagem: $e');
    }
  }

  Future<void> _tirarFoto() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (foto != null) {
        setState(() {
          _imagens.add(foto.path);
        });
      }
    } catch (e) {
      _mostrarMensagem('Erro ao tirar foto: $e');
    }
  }

  void _removerImagem(int index) {
    setState(() {
      _imagens.removeAt(index);
    });
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      _mostrarMensagem('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    if (_imagens.isEmpty) {
      final confirmar = await _confirmarSemImagem();
      if (!confirmar) return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      final animalAtualizado = widget.animal.copyWith(
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        raca: _racaController.text.trim(),
        cor: _corController.text.trim(),
        especie: _especieController.text.trim(),
        sexo: _sexo,
        tipo: _tipo,
        cidade: _cidadeController.text.trim(),
        bairro: _bairroController.text.trim(),
        imagens: _imagens,
        dataAtualizacao: DateTime.now(),

        // Campos específicos para perdidos
        ultimoLocalVisto: _ultimoLocalVistoController.text.trim().isNotEmpty
            ? _ultimoLocalVistoController.text.trim()
            : null,
        enderecoDesaparecimento:
            _enderecoDesaparecimentoController.text.trim().isNotEmpty
            ? _enderecoDesaparecimentoController.text.trim()
            : null,
        dataDesaparecimento:
            _dataDesaparecimentoController.text.trim().isNotEmpty
            ? _dataDesaparecimentoController.text.trim()
            : null,

        // Campos específicos para encontrados
        localEncontro: _localEncontroController.text.trim().isNotEmpty
            ? _localEncontroController.text.trim()
            : null,
        enderecoEncontro: _enderecoEncontroController.text.trim().isNotEmpty
            ? _enderecoEncontroController.text.trim()
            : null,
        dataEncontro: _dataEncontroController.text.trim().isNotEmpty
            ? _dataEncontroController.text.trim()
            : null,
        situacaoSaude: _situacaoSaudeController.text.trim().isNotEmpty
            ? _situacaoSaudeController.text.trim()
            : null,
        contatoResponsavel: _contatoResponsavelController.text.trim().isNotEmpty
            ? _contatoResponsavelController.text.trim()
            : null,
      );

      await AnimalService.atualizarAnimal(animalAtualizado);

      Navigator.pop(context, true);
    } catch (e) {
      _mostrarMensagem('Erro ao atualizar animal: $e');
      setState(() {
        _carregando = false;
      });
    }
  }

  Future<bool> _confirmarSemImagem() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sem Imagens"),
            content: const Text(
              "Deseja continuar sem adicionar imagens do animal? "
              "Imagens ajudam muito no reconhecimento.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Continuar"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), duration: const Duration(seconds: 3)),
    );
  }

  void _confirmarCancelar() async {
    final sair = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Descartar Alterações"),
        content: const Text("Tem certeza que deseja descartar as alterações?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Descartar"),
          ),
        ],
      ),
    );

    if (sair == true) {
      Navigator.pop(context);
    }
  }

  Widget _buildImagemPreview() {
    if (_imagens.isEmpty) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              "Nenhuma imagem adicionada",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Imagens do Animal",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _imagens.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _imagens[index].startsWith('assets/')
                          ? Image.asset(
                              _imagens[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(_imagens[index]),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removerImagem(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCamposPerdidos() {
    if (_tipo != 'perdido') return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Informações do Desaparecimento",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _ultimoLocalVistoController,
          decoration: const InputDecoration(
            labelText: "Último Local Visto",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on, color: Colors.orange),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _enderecoDesaparecimentoController,
          decoration: const InputDecoration(
            labelText: "Endereço do Desaparecimento",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.place, color: Colors.orange),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dataDesaparecimentoController,
          decoration: const InputDecoration(
            labelText: "Data do Desaparecimento",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.orange),
            hintText: "Ex: 15/10/2024",
          ),
        ),
      ],
    );
  }

  Widget _buildCamposEncontrados() {
    if (_tipo != 'encontrado') return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Informações do Encontro",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _localEncontroController,
          decoration: const InputDecoration(
            labelText: "Local do Encontro",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on, color: Colors.green),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _enderecoEncontroController,
          decoration: const InputDecoration(
            labelText: "Endereço do Encontro",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.place, color: Colors.green),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _dataEncontroController,
          decoration: const InputDecoration(
            labelText: "Data do Encontro",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
            hintText: "Ex: 15/10/2024",
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _situacaoSaudeController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: "Situação de Saúde",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.medical_services, color: Colors.green),
            hintText: "Descreva o estado de saúde do animal",
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _contatoResponsavelController,
          decoration: const InputDecoration(
            labelText: "Contato do Responsável",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone, color: Colors.green),
            hintText: "Telefone para contato",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar ${widget.animal.isPerdido ? 'Animal Perdido' : 'Animal Encontrado'}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: widget.animal.isPerdido ? Colors.orange : Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _confirmarCancelar,
        ),
        actions: [
          if (!_carregando)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.white),
              onPressed: _salvarAlteracoes,
            ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Seção de Tipo
                      const Text(
                        "Tipo de Cadastro",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _tipo,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'perdido',
                              child: Row(
                                children: [
                                  Icon(Icons.warning, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text('Animal Perdido'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'encontrado',
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Animal Encontrado'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _tipo = value!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Seção de Imagens
                      _buildImagemPreview(),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _selecionarImagem,
                              icon: const Icon(Icons.photo_library),
                              label: const Text("Galeria"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _tirarFoto,
                              icon: const Icon(Icons.camera_alt),
                              label: const Text("Câmera"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Informações Básicas
                      const Text(
                        "Informações Básicas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: "Nome do Animal *",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.pets),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe o nome do animal';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Descrição *",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.description),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, informe uma descrição';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _especieController,
                              decoration: const InputDecoration(
                                labelText: "Espécie *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.emoji_nature),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe a espécie';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _racaController,
                              decoration: const InputDecoration(
                                labelText: "Raça *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.agriculture),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe a raça';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _corController,
                              decoration: const InputDecoration(
                                labelText: "Cor *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.color_lens),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe a cor';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _sexo,
                              decoration: const InputDecoration(
                                labelText: "Sexo *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.male),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Macho',
                                  child: Text('Macho'),
                                ),
                                DropdownMenuItem(
                                  value: 'Fêmea',
                                  child: Text('Fêmea'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sexo = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, selecione o sexo';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cidadeController,
                              decoration: const InputDecoration(
                                labelText: "Cidade *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe a cidade';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _bairroController,
                              decoration: const InputDecoration(
                                labelText: "Bairro *",
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.place),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor, informe o bairro';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      // Campos específicos baseados no tipo
                      _buildCamposPerdidos(),
                      _buildCamposEncontrados(),

                      const SizedBox(height: 32),

                      // Botão Salvar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvarAlteracoes,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tipo == 'perdido'
                                ? Colors.orange
                                : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _carregando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "SALVAR ALTERAÇÕES",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _racaController.dispose();
    _corController.dispose();
    _especieController.dispose();
    _cidadeController.dispose();
    _bairroController.dispose();
    _ultimoLocalVistoController.dispose();
    _enderecoDesaparecimentoController.dispose();
    _dataDesaparecimentoController.dispose();
    _localEncontroController.dispose();
    _enderecoEncontroController.dispose();
    _dataEncontroController.dispose();
    _situacaoSaudeController.dispose();
    _contatoResponsavelController.dispose();
    super.dispose();
  }
}

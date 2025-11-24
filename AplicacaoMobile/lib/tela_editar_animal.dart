import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
  String _especie = 'Cachorro'; // ✅ ESPECIE COM ESCOLHA

  // ✅ USA O TIPO DO ANIMAL ORIGINAL
  String get _tipo => widget.animal.tipo;

  // ✅ SISTEMA DE IMAGENS AVANÇADO
  final List<String> _imagensAntigas = [];
  final List<bool> _manterImagemAntiga = [true, true, true, true];
  final List<XFile?> _novasImagens = [null, null, null, null];
  final ImagePicker _picker = ImagePicker();

  bool _carregando = false;
  bool _bloquearBotao = false;

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
    _especie = animal.especie; // ✅ CARREGAR ESPECIE
    _cidadeController.text = animal.cidade;
    _bairroController.text = animal.bairro;
    _sexo = animal.sexo;

    // ✅ CARREGAR IMAGENS EXISTENTES DO ANIMAL
    _imagensAntigas.clear();
    _imagensAntigas.addAll(animal.imagens);

    // ✅ INICIALIZAR TODAS AS IMAGENS COMO "MANTER"
    for (int i = 0; i < 4; i++) {
      _manterImagemAntiga[i] = i < _imagensAntigas.length;
    }

    print('🖼️ Imagens antigas carregadas: ${_imagensAntigas.length}');
    for (var img in _imagensAntigas) {
      print('📸 Imagem: $img');
    }

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

  // ✅ MÉTODO PARA ADICIONAR NOVA IMAGEM EM POSIÇÃO ESPECÍFICA
  Future<void> _adicionarNovaImagem(int index) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _novasImagens[index] = pickedFile;
        _manterImagemAntiga[index] =
            false; // Não manter a antiga se adicionou nova
      });
    }
  }

  // ✅ MÉTODO PARA REMOVER IMAGEM (tanto antiga quanto nova)
  void _removerImagem(int index) {
    setState(() {
      if (_novasImagens[index] != null) {
        // Remove imagem nova
        _novasImagens[index] = null;
        _manterImagemAntiga[index] = true; // Volta a manter a antiga
      } else if (_manterImagemAntiga[index] && index < _imagensAntigas.length) {
        // Marca para não manter a antiga
        _manterImagemAntiga[index] = false;
      } else {
        // Se não tem imagem, volta ao estado inicial
        _manterImagemAntiga[index] = true;
      }
    });
  }

  // ✅ MÉTODO PARA ALTERNAR ENTRE MANTER/REMOVER IMAGEM ANTIGA
  void _alternarManterImagem(int index) {
    setState(() {
      _manterImagemAntiga[index] = !_manterImagemAntiga[index];
      // Se decidiu manter a antiga, remove qualquer imagem nova
      if (_manterImagemAntiga[index]) {
        _novasImagens[index] = null;
      }
    });
  }

  // ✅ MÉTODO CORRETO PARA ENVIAR EDIÇÃO COM IMAGENS
  Future<void> _enviarEdicaoParaAprovacao() async {
    if (_carregando || _bloquearBotao) return;

    setState(() {
      _carregando = true;
      _bloquearBotao = true;
    });

    try {
      print('📤 Enviando edição para aprovação...');

      // ✅ CRIAR REQUEST MULTIPART
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.15.16:8000/api/editados'),
      );

      // ✅ ADICIONAR CAMPOS DE TEXTO
      request.fields['animal_id'] = widget.animal.id.toString();
      request.fields['user_id'] = '1'; // ✅ Substitua pelo ID do usuário logado
      request.fields['n_nome'] = _nomeController.text.trim();
      request.fields['n_raca'] = _racaController.text.trim();
      request.fields['n_cor'] = _corController.text.trim();
      request.fields['n_especie'] = _especie;
      request.fields['n_sexo'] = _sexo;
      request.fields['n_descricao'] = _descricaoController.text.trim();
      request.fields['n_cidade'] = _cidadeController.text.trim();
      request.fields['n_bairro'] = _bairroController.text.trim();
      request.fields['n_situacao'] = _tipo;
      request.fields['n_status'] = 'ativo';

      // ✅ CAMPOS ESPECÍFICOS PARA PERDIDOS
      if (_tipo == 'perdido') {
        request.fields['n_ultimo_local_visto'] = _ultimoLocalVistoController
            .text
            .trim();
        request.fields['n_endereco_desaparecimento'] =
            _enderecoDesaparecimentoController.text.trim();
        request.fields['n_data_desaparecimento'] =
            _dataDesaparecimentoController.text.trim();
      }

      // ✅ CAMPOS ESPECÍFICOS PARA ENCONTRADOS
      if (_tipo == 'encontrado') {
        request.fields['n_local_encontro'] = _localEncontroController.text
            .trim();
        request.fields['n_endereco_encontro'] = _enderecoEncontroController.text
            .trim();
        request.fields['n_data_encontro'] = _dataEncontroController.text.trim();
        request.fields['n_situacao_saude'] = _situacaoSaudeController.text
            .trim();
        request.fields['n_contato_responsavel'] = _contatoResponsavelController
            .text
            .trim();
      }

      // ✅ PROCESSAR IMAGENS - LÓGICA CORRETA
      for (int i = 0; i < 4; i++) {
        final campoImagem = 'n_imagem${i + 1}';

        if (_novasImagens[i] != null) {
          // ✅ ENVIAR IMAGEM NOVA
          var file = await http.MultipartFile.fromPath(
            campoImagem,
            _novasImagens[i]!.path,
          );
          request.files.add(file);
          print(
            '📤 Enviando nova imagem para $campoImagem: ${_novasImagens[i]!.path}',
          );
        } else if (_manterImagemAntiga[i] && i < _imagensAntigas.length) {
          // ✅ MANTER IMAGEM ANTIGA (enviar como string)
          request.fields[campoImagem] = _imagensAntigas[i];
          print(
            '🖼️ Mantendo imagem antiga para $campoImagem: ${_imagensAntigas[i]}',
          );
        } else {
          // ✅ REMOVER IMAGEM (enviar string vazia)
          request.fields[campoImagem] = '';
          print('🗑️ Removendo imagem para $campoImagem');
        }
      }

      print('📦 Enviando request multipart...');

      // ✅ ENVIAR REQUEST
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      print('📡 Status da resposta: ${response.statusCode}');
      print('📨 Body da resposta: $responseString');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(responseString);
        if (responseData['status'] == 'success') {
          _mostrarMensagem('✅ Edição enviada para aprovação!');
          if (mounted) {
            Navigator.pop(context, true);
          }
        } else {
          throw Exception('Erro do servidor: ${responseData['message']}');
        }
      } else {
        final errorData = json.decode(responseString);
        throw Exception(
          'Erro ${response.statusCode}: ${errorData['message'] ?? responseString}',
        );
      }
    } catch (e) {
      print('❌ Erro ao enviar edição: $e');
      _mostrarMensagem('❌ Erro ao enviar edição: $e');
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
          _bloquearBotao = false;
        });
      }
    }
  }

  Future<void> _salvarAlteracoes() async {
    if (!_formKey.currentState!.validate()) {
      _mostrarMensagem('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    await _enviarEdicaoParaAprovacao();
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 3),
        backgroundColor: mensagem.contains('Erro') ? Colors.red : Colors.green,
      ),
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

  // ✅ WIDGET DE IMAGEM INDIVIDUAL
  Widget _buildImagemWidget(int index) {
    final temImagemAntiga =
        index < _imagensAntigas.length && _manterImagemAntiga[index];
    final temImagemNova = _novasImagens[index] != null;

    String imageUrl = '';
    bool isNova = false;

    if (temImagemNova) {
      imageUrl = _novasImagens[index]!.path;
      isNova = true;
    } else if (temImagemAntiga) {
      imageUrl = _imagensAntigas[index];
      isNova = false;
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNova ? Colors.green : Colors.blue,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // IMAGEM
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImagem();
                      },
                    )
                  : Image.file(
                      File(imageUrl),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholderImagem();
                      },
                    ),
            )
          else
            _buildPlaceholderImagem(),

          // BADGE
          if (imageUrl.isNotEmpty)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isNova ? Colors.green : Colors.blue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isNova ? 'NOVA' : 'ATUAL',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // BOTÃO DE AÇÃO
          Positioned(
            bottom: 4,
            right: 4,
            child: Row(
              children: [
                if (temImagemAntiga && !temImagemNova)
                  GestureDetector(
                    onTap: () => _alternarManterImagem(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),

                if (temImagemNova)
                  GestureDetector(
                    onTap: () => _removerImagem(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImagem() {
    return Container(
      color: Colors.grey[100],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate, size: 24, color: Colors.grey),
          SizedBox(height: 4),
          Text("Adicionar", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // ✅ WIDGET DA SEÇÃO DE IMAGENS
  Widget _buildSelecaoImagens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Imagens do Animal",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "Toque em uma imagem para substituí-la. Toque no ❌ para remover.",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 12),

        // GRADE DE IMAGENS
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _adicionarNovaImagem(index),
              child: _buildImagemWidget(index),
            );
          },
        ),

        const SizedBox(height: 12),
        Text(
          "🟦 AZUL = Imagem atual | 🟩 VERDE = Nova imagem",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontStyle: FontStyle.italic,
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
    final corPrincipal = _tipo == 'perdido' ? Colors.orange : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar Animal ${_tipo == 'perdido' ? 'Perdido' : 'Encontrado'}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: corPrincipal,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ BADGE MOSTRANDO O TIPO DO ANIMAL
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _tipo == 'perdido'
                          ? Colors.orange[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _tipo == 'perdido'
                            ? Colors.orange[200]!
                            : Colors.green[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _tipo == 'perdido' ? Icons.warning : Icons.search,
                          color: _tipo == 'perdido'
                              ? Colors.orange[700]
                              : Colors.green[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _tipo == 'perdido'
                                    ? "Animal Perdido"
                                    : "Animal Encontrado",
                                style: TextStyle(
                                  color: _tipo == 'perdido'
                                      ? Colors.orange[800]
                                      : Colors.green[800],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _tipo == 'perdido'
                                    ? "Editando informações de animal perdido"
                                    : "Editando informações de animal encontrado",
                                style: TextStyle(
                                  color: _tipo == 'perdido'
                                      ? Colors.orange[800]
                                      : Colors.green[800],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ✅ SEÇÃO DE IMAGENS (SISTEMA COMPLETO)
                  _buildSelecaoImagens(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Informações Básicas
                  const Text(
                    "Informações Básicas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        // ✅ ESPECIE COM DROPDOWN
                        child: DropdownButtonFormField<String>(
                          value: _especie,
                          decoration: const InputDecoration(
                            labelText: "Espécie *",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.emoji_nature),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Cachorro',
                              child: Text('Cachorro'),
                            ),
                            DropdownMenuItem(
                              value: 'Gato',
                              child: Text('Gato'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _especie = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, selecione a espécie';
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

                  // ✅ CAMPOS ESPECÍFICOS BASEADOS NO TIPO DO ANIMAL
                  _buildCamposPerdidos(),
                  _buildCamposEncontrados(),

                  const SizedBox(height: 32),

                  // Botão Salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_carregando || _bloquearBotao)
                          ? null
                          : _salvarAlteracoes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_carregando || _bloquearBotao)
                            ? Colors.grey
                            : corPrincipal,
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
                              "ENVIAR PARA APROVAÇÃO",
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

          // Loading overlay
          if (_carregando)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Enviando para aprovação...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Não feche o aplicativo",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _racaController.dispose();
    _corController.dispose();
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

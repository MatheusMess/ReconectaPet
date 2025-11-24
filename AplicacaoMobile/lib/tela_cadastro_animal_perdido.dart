import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'animal.dart';
import 'autenticacao.dart';
import 'animal_api.dart';

class TelaCadastroAnimalPerdido extends StatefulWidget {
  final Function(Animal)? onSalvar;

  const TelaCadastroAnimalPerdido({super.key, this.onSalvar});

  @override
  State<TelaCadastroAnimalPerdido> createState() =>
      _TelaCadastroAnimalPerdidoState();
}

class _TelaCadastroAnimalPerdidoState extends State<TelaCadastroAnimalPerdido> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController racaController = TextEditingController();
  final TextEditingController corController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  final TextEditingController ultimoLocalController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController dataDesaparecimentoController =
      TextEditingController();

  String? especieSelecionada;
  String? sexoSelecionado;
  final List<String> cores = [];
  final List<XFile> fotosExtras = [];
  XFile? fotoPrincipal;
  final ImagePicker picker = ImagePicker();

  bool _salvando = false;
  bool _bloquearBotao = false; // ✅ Previne duplo clique

  Future<void> adicionarFoto({bool isPrincipal = false}) async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        if (isPrincipal) {
          fotoPrincipal = pickedFile;
        } else if (fotosExtras.length < 3) {
          fotosExtras.add(pickedFile);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Máximo de 3 fotos extras atingido"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }

  void removerFotoPrincipal() {
    setState(() {
      fotoPrincipal = null;
    });
  }

  void removerFotoExtra(int index) {
    setState(() {
      fotosExtras.removeAt(index);
    });
  }

  void adicionarCor() {
    if (corController.text.isNotEmpty) {
      setState(() {
        cores.add(corController.text);
        corController.clear();
      });
    }
  }

  void removerCor(int index) {
    setState(() {
      cores.removeAt(index);
    });
  }

  Future<void> _selecionarDataDesaparecimento() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (dataSelecionada != null) {
      final dataFormatada =
          "${dataSelecionada.day.toString().padLeft(2, '0')}/"
          "${dataSelecionada.month.toString().padLeft(2, '0')}/"
          "${dataSelecionada.year}";

      setState(() {
        dataDesaparecimentoController.text = dataFormatada;
      });
    }
  }

  Future<void> salvarAnimal() async {
    // ✅ CORREÇÃO: Impede duplo clique
    if (_salvando || _bloquearBotao) {
      print('⏳ Cadastro já em andamento, ignorando clique...');
      return;
    }

    // Validar campos obrigatórios
    if (nomeController.text.isEmpty ||
        racaController.text.isEmpty ||
        cores.isEmpty ||
        observacoesController.text.isEmpty ||
        especieSelecionada == null ||
        sexoSelecionado == null ||
        ultimoLocalController.text.isEmpty ||
        cidadeController.text.isEmpty ||
        bairroController.text.isEmpty ||
        enderecoController.text.isEmpty ||
        dataDesaparecimentoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Preencha todos os campos obrigatórios (*)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar foto principal
    if (fotoPrincipal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Adicione pelo menos uma foto principal"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ BLOQUEIA BOTÃO IMEDIATAMENTE
    setState(() {
      _salvando = true;
      _bloquearBotao = true;
    });

    print('🔄 INICIANDO CADASTRO ANIMAL PERDIDO...');

    try {
      // Obter usuário logado
      final usuarioLogado = AuthService().usuarioLogado;
      if (usuarioLogado == null) {
        throw Exception('Usuário não está logado');
      }

      // Preparar imagens para upload - ✅ CORREÇÃO: Verifica se arquivos existem
      final List<File> imagensParaUpload = [];
      if (fotoPrincipal != null) {
        final file = File(fotoPrincipal!.path);
        if (await file.exists()) {
          imagensParaUpload.add(file);
          print('📸 Foto principal: ${file.path}');
        } else {
          throw Exception('Arquivo da foto principal não encontrado');
        }
      }

      for (var foto in fotosExtras) {
        final file = File(foto.path);
        if (await file.exists()) {
          imagensParaUpload.add(file);
          print('📸 Foto extra: ${file.path}');
        }
      }

      print('📦 Total de imagens para upload: ${imagensParaUpload.length}');

      // Criar animal com status PENDENTE para aprovação
      final animal = Animal(
        nome: nomeController.text,
        descricao: observacoesController.text,
        raca: racaController.text,
        cor: cores.join(", "),
        especie: especieSelecionada!,
        sexo: sexoSelecionado!,
        imagens: [], // Será preenchido pela API após upload
        cidade: cidadeController.text,
        bairro: bairroController.text,
        donoId: usuarioLogado.id,
        // CAMPOS ESPECÍFICOS PARA ANIMAL PERDIDO
        ultimoLocalVisto: ultimoLocalController.text,
        enderecoDesaparecimento: enderecoController.text,
        dataDesaparecimento: dataDesaparecimentoController.text,
        // Identificar como animal perdido
        tipo: 'perdido',
        ativo: false, // Inativo até ser aprovado
        // Campos de usuário para exibição
        userNome: usuarioLogado.nome,
        userTelefone: usuarioLogado.telefone,
        userEmail: usuarioLogado.email,
      );

      print('🚀 ENVIANDO PARA API...');

      // ✅ ENVIAR PARA API LARAVEL COM STATUS PENDENTE
      final animalSalvo = await AnimalApiService.cadastrarAnimalPerdido(
        animal: animal,
        imagens: imagensParaUpload,
      );

      print('✅ ANIMAL PERDIDO CADASTRADO COM SUCESSO! ID: ${animalSalvo.id}');

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Animal enviado para aprovação!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Aguarde a análise do administrador.'),
            ],
          ),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Chamar callback se existir
      widget.onSalvar?.call(animalSalvo);

      // Voltar para tela anterior após 2 segundos
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ ERRO NO CADASTRO: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '❌ Erro ao enviar animal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(e.toString().replaceAll('Exception: ', '')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      // ✅ LIBERA BOTÃO APÓS CONCLUSÃO (sucesso ou erro)
      if (mounted) {
        setState(() {
          _salvando = false;
          _bloquearBotao = false;
        });
      }
      print('🏁 PROCESSO FINALIZADO - Botão liberado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastrar Animal Perdido",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.red[700],
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_salvando)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da seção
                _buildSectionTitle("ANIMAL PERDIDO - PROCURA-SE"),

                // Informação sobre aprovação
                _buildInfoAprovacao(),
                const SizedBox(height: 20),

                // FOTO PRINCIPAL
                _buildSectionTitle("Foto Principal *", fontSize: 14),
                const SizedBox(height: 8),
                _buildFotoPrincipal(),
                const SizedBox(height: 20),

                // FOTOS EXTRAS (MÁXIMO 3)
                _buildSectionTitle("Fotos Extras (opcional)", fontSize: 14),
                const SizedBox(height: 8),
                _buildFotosExtras(),
                const SizedBox(height: 20),

                // DADOS DO ANIMAL
                _buildSectionTitle("Dados do Animal Perdido", fontSize: 14),
                const SizedBox(height: 12),

                // Nome
                _buildTextField(
                  controller: nomeController,
                  label: "Nome do animal *",
                  hint: "Ex: Rex, Luna, Bob",
                ),
                const SizedBox(height: 16),

                // Raça
                _buildTextField(
                  controller: racaController,
                  label: "Raça do animal *",
                  hint: "Ex: Labrador, Siamesa, SRD",
                ),
                const SizedBox(height: 16),

                // Cores
                _buildCorField(),
                const SizedBox(height: 16),

                // Espécie
                _buildDropdown(
                  value: especieSelecionada,
                  hint: "Espécie *",
                  items: const ["Cachorro", "Gato"],
                  onChanged: (value) =>
                      setState(() => especieSelecionada = value),
                ),
                const SizedBox(height: 16),

                // Sexo
                _buildDropdown(
                  value: sexoSelecionado,
                  hint: "Sexo *",
                  items: const ["Macho", "Fêmea"],
                  onChanged: (value) => setState(() => sexoSelecionado = value),
                ),
                const SizedBox(height: 20),

                // LOCAL DO DESAPARECIMENTO
                _buildSectionTitle("Local do Desaparecimento", fontSize: 14),
                const SizedBox(height: 12),

                // Último local visto
                _buildTextField(
                  controller: ultimoLocalController,
                  label: "Último local visto *",
                  hint: "Ex: Parque Central, Praça da Matriz, Rua...",
                ),
                const SizedBox(height: 16),

                // Cidade
                _buildTextField(
                  controller: cidadeController,
                  label: "Cidade *",
                  hint: "Ex: São Paulo, Rio de Janeiro",
                ),
                const SizedBox(height: 16),

                // Bairro
                _buildTextField(
                  controller: bairroController,
                  label: "Bairro *",
                  hint: "Ex: Centro, Jardins, Copacabana",
                ),
                const SizedBox(height: 16),

                // Endereço aproximado
                _buildTextField(
                  controller: enderecoController,
                  label: "Endereço aproximado *",
                  hint: "Ex: Rua das Flores, 123",
                ),
                const SizedBox(height: 16),

                // Data do desaparecimento
                _buildDateField(),
                const SizedBox(height: 20),

                // OBSERVAÇÕES
                _buildSectionTitle("Observações Importantes", fontSize: 14),
                const SizedBox(height: 8),
                _buildObservacoesField(),
                const SizedBox(height: 30),

                // BOTÃO SALVAR
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Loading overlay
          if (_salvando)
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

  Widget _buildInfoAprovacao() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aguardando Aprovação",
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Seu animal será analisado por um administrador antes de aparecer publicamente na seção de animais perdidos.",
                  style: TextStyle(color: Colors.orange[800], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {double fontSize = 16}) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        color: Colors.red[800],
      ),
    );
  }

  Widget _buildFotoPrincipal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: fotoPrincipal != null
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(fotoPrincipal!.path),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                          onPressed: removerFotoPrincipal,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Adicionar foto principal",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        "(Obrigatório)",
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => adicionarFoto(isPrincipal: true),
            icon: const Icon(Icons.camera_alt, size: 18),
            label: const Text("Selecionar Foto Principal"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFotosExtras() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...fotosExtras.asMap().entries.map((entry) {
              final index = entry.key;
              final foto = entry.value;
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(foto.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                        onPressed: () => removerFotoExtra(index),
                      ),
                    ),
                  ),
                ],
              );
            }),
            if (fotosExtras.length < 3)
              GestureDetector(
                onTap: () => adicionarFoto(isPrincipal: false),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.grey[500], size: 30),
                      const SizedBox(height: 4),
                      Text(
                        "Adicionar",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        "(${3 - fotosExtras.length} restantes)",
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Máximo de 3 fotos extras (opcional)",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildCorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: corController,
          decoration: InputDecoration(
            labelText: "Cor do animal *",
            hintText: "Ex: Preto, Branco, Marrom",
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.red),
              onPressed: adicionarCor,
            ),
          ),
          onSubmitted: (_) => adicionarCor(),
        ),
        const SizedBox(height: 8),
        if (cores.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(cores.length, (index) {
              return Chip(
                label: Text(cores[index], style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => removerCor(index),
                backgroundColor: Colors.red[50],
              );
            }),
          ),
        const SizedBox(height: 4),
        Text(
          "Pressione Enter ou clique no + para adicionar cada cor",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: dataDesaparecimentoController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Data do desaparecimento *",
            hintText: "Clique para selecionar a data",
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selecionarDataDesaparecimento,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObservacoesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: observacoesController,
          decoration: const InputDecoration(
            labelText: "Observações importantes *",
            hintText:
                "Descreva características marcantes, comportamento, detalhes importantes para identificação, etc.",
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          textAlignVertical: TextAlignVertical.top,
        ),
        const SizedBox(height: 4),
        Text(
          "Essas informações ajudarão outras pessoas a identificar e encontrar seu animal",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_salvando || _bloquearBotao) ? null : salvarAnimal,
            style: ElevatedButton.styleFrom(
              backgroundColor: (_salvando || _bloquearBotao)
                  ? Colors.grey
                  : Colors.red[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: _salvando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "ENVIAR PARA APROVAÇÃO",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "* Todos os campos marcados com asterisco são obrigatórios",
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    racaController.dispose();
    corController.dispose();
    observacoesController.dispose();
    ultimoLocalController.dispose();
    cidadeController.dispose();
    bairroController.dispose();
    enderecoController.dispose();
    dataDesaparecimentoController.dispose();
    super.dispose();
  }
}

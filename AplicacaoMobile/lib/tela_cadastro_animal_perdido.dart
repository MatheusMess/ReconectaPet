import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'animal.dart';

class TelaCadastroAnimalPerdido extends StatefulWidget {
  final Function(Animal) onSalvar;

  const TelaCadastroAnimalPerdido({super.key, required this.onSalvar});

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
        } else {
          fotosExtras.add(pickedFile);
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

  void salvarAnimal() {
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
          content: Text("Preencha todos os campos obrigatórios"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Coletar todas as imagens (principal + extras)
    final List<String> todasImagens = [];
    if (fotoPrincipal != null) {
      todasImagens.add(fotoPrincipal!.path);
    }
    for (var foto in fotosExtras) {
      todasImagens.add(foto.path);
    }

    // Se não tiver nenhuma foto, usar a padrão
    if (todasImagens.isEmpty) {
      todasImagens.add("assets/cachorro1.png");
    }

    // CORREÇÃO: Usar os novos campos específicos para animais perdidos
    final animal = Animal(
      nome: nomeController.text,
      descricao: observacoesController.text,
      raca: racaController.text,
      cor: cores.join(", "),
      especie: especieSelecionada!,
      sexo: sexoSelecionado!,
      imagens: todasImagens,
      cidade: cidadeController.text,
      bairro: bairroController.text,
      donoId: "usuario_atual", // Será substituído pela tela principal
      // CAMPOS ESPECÍFICOS PARA ANIMAL PERDIDO
      ultimoLocalVisto: ultimoLocalController.text,
      enderecoDesaparecimento: enderecoController.text,
      dataDesaparecimento: dataDesaparecimentoController.text,

      // Identificar como animal perdido
      tipo: 'perdido',
    );

    widget.onSalvar(animal);
    Navigator.pop(context);
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da seção
            _buildSectionTitle("INFORMAÇÕES DO ANIMAL PERDIDO"),

            // FOTO PRINCIPAL
            _buildSectionTitle("Foto Principal", fontSize: 14),
            const SizedBox(height: 8),
            _buildFotoPrincipal(),
            const SizedBox(height: 20),

            // FOTOS EXTRAS
            _buildSectionTitle("Fotos Extras", fontSize: 14),
            const SizedBox(height: 8),
            _buildFotosExtras(),
            const SizedBox(height: 20),

            // DADOS DO ANIMAL
            _buildSectionTitle("Dados do Animal", fontSize: 14),
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
              items: ["Cachorro", "Gato"],
              onChanged: (value) => setState(() => especieSelecionada = value),
            ),
            const SizedBox(height: 16),

            // Sexo
            _buildDropdown(
              value: sexoSelecionado,
              hint: "Sexo *",
              items: ["Macho", "Fêmea"],
              onChanged: (value) => setState(() => sexoSelecionado = value),
            ),
            const SizedBox(height: 20),

            // LOCALIZAÇÃO
            _buildSectionTitle("Local do Desaparecimento", fontSize: 14),
            const SizedBox(height: 12),

            // Último local visto
            _buildTextField(
              controller: ultimoLocalController,
              label: "Último local visto *",
              hint: "Ex: Parque Central, Praça da Matriz",
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

            // Endereço
            _buildTextField(
              controller: enderecoController,
              label: "Endereço *",
              hint: "Ex: Rua das Flores, 123",
            ),
            const SizedBox(height: 16),

            // Data do desaparecimento
            _buildTextField(
              controller: dataDesaparecimentoController,
              label: "Data do desaparecimento *",
              hint: "Ex: 12/08/2025",
            ),
            const SizedBox(height: 20),

            // OBSERVAÇÕES
            _buildSectionTitle("Observações", fontSize: 14),
            const SizedBox(height: 8),
            _buildObservacoesField(),
            const SizedBox(height: 30),

            // BOTÃO SALVAR
            _buildSaveButton(),
          ],
        ),
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
            if (fotosExtras.length < 5)
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
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "Máximo de 5 fotos extras",
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
      ],
    );
  }

  Widget _buildObservacoesField() {
    return TextField(
      controller: observacoesController,
      decoration: const InputDecoration(
        labelText: "Observações adicionais *",
        hintText:
            "Descreva características marcantes, comportamento, detalhes importantes para identificação, etc.",
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textAlignVertical: TextAlignVertical.top,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        underline: const SizedBox(),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: salvarAnimal,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
        child: const Text(
          "CADASTRAR ANIMAL PERDIDO",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

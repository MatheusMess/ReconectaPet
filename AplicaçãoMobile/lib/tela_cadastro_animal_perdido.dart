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
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController ultimoLocalController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController dataDesaparecimentoController =
      TextEditingController();

  String? especieSelecionada;
  String? sexoSelecionado;
  final List<String> cores = [];
  final List<XFile> fotos = [];
  final ImagePicker picker = ImagePicker();

  Future<void> adicionarFoto() async {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        fotos.add(pickedFile);
      });
    }
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
        descricaoController.text.isEmpty ||
        especieSelecionada == null ||
        sexoSelecionado == null ||
        ultimoLocalController.text.isEmpty ||
        cidadeController.text.isEmpty ||
        bairroController.text.isEmpty ||
        enderecoController.text.isEmpty ||
        dataDesaparecimentoController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Preencha todos os campos")));
      return;
    }

    final animal = Animal(
      nome: nomeController.text,
      raca: racaController.text,
      cor: cores.join(", "),
      especie: especieSelecionada!,
      sexo: sexoSelecionado!,
      descricao: descricaoController.text,
      imagem: fotos.isNotEmpty ? fotos[0].path : "assets/cachorro1.png",
      ultimoLocal: ultimoLocalController.text,
      cidade: cidadeController.text,
      bairro: bairroController.text,
      endereco: enderecoController.text,
      dataDesaparecimento: dataDesaparecimentoController.text,
    );

    widget.onSalvar(animal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Animal Perdido"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "INFORMAÇÕES DO ANIMAL PERDIDO",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: racaController,
              decoration: const InputDecoration(
                labelText: "Qual a raça do seu animal?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: corController,
              decoration: InputDecoration(
                labelText: "Adicione uma cor",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: adicionarCor,
                ),
              ),
              onSubmitted: (_) => adicionarCor(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(cores.length, (index) {
                return Chip(
                  label: Text(cores[index]),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => removerCor(index),
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text("Qual a espécie do animal?"),
            DropdownButton<String>(
              value: especieSelecionada,
              hint: const Text("Selecione a espécie"),
              items: [
                "Cachorro",
                "Gato",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => especieSelecionada = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(
                labelText: "Qual o nome do seu animal?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Qual o sexo do seu animal?"),
            DropdownButton<String>(
              value: sexoSelecionado,
              hint: const Text("Selecione o sexo"),
              items: [
                "Macho",
                "Fêmea",
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) => setState(() => sexoSelecionado = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ultimoLocalController,
              decoration: const InputDecoration(
                labelText: "Último local visto",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cidadeController,
              decoration: const InputDecoration(
                labelText: "Cidade",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bairroController,
              decoration: const InputDecoration(
                labelText: "Bairro",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: enderecoController,
              decoration: const InputDecoration(
                labelText: "Endereço",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: dataDesaparecimentoController,
              decoration: const InputDecoration(
                labelText: "Quando você perdeu o animal?",
                hintText: "Ex: 12/08/2025",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: "Descrição adicional",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text("Fotos do animal"),
            Wrap(
              spacing: 8,
              children: [
                ...fotos.map(
                  (f) => Image.file(
                    File(f.path),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  onPressed: adicionarFoto,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: salvarAnimal,
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

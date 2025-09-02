import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';
import 'tela_cadastro_animal_perdido.dart';
import 'tela_detalhes_animal.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final List<Animal> animaisPerdidos = [];

  void adicionarAnimal(Animal animal) {
    setState(() {
      animaisPerdidos.add(animal);
    });
  }

  void mostrarPopupCadastro() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text("Cadastrar Animal Perdido"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TelaCadastroAnimalPerdido(onSalvar: adicionarAnimal),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text("Cadastrar Animal Encontrado"),
            onTap: () {
              Navigator.pop(context);
              // Criar depois
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela Principal"),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: mostrarPopupCadastro,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.cyan),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Sair"),
              onTap: () {
                Navigator.pop(context);
                // Navegação para login
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: animaisPerdidos.length,
        itemBuilder: (context, index) {
          final animal = animaisPerdidos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: Image.file(
                File(animal.imagem),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
              title: Text(animal.nome),
              subtitle: Text(animal.descricao),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaDetalhesAnimal(animal: animal),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

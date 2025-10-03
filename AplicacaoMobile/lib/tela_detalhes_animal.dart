import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';

class TelaDetalhesAnimal extends StatelessWidget {
  final Animal animal;

  const TelaDetalhesAnimal({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          animal.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem principal
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(animal.imagem),
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Informações em cards
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _infoRow(Icons.pets, "Raça", animal.raca),
                    _infoRow(Icons.color_lens, "Cor", animal.cor),
                    _infoRow(Icons.category, "Espécie", animal.especie),
                    _infoRow(Icons.male, "Sexo", animal.sexo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _infoRow(Icons.place, "Último Local", animal.ultimoLocal),
                    _infoRow(Icons.location_city, "Cidade", animal.cidade),
                    _infoRow(Icons.map, "Bairro", animal.bairro),
                    _infoRow(Icons.home, "Endereço", animal.endereco),
                    _infoRow(
                      Icons.calendar_today,
                      "Data do Desaparecimento",
                      animal.dataDesaparecimento,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Descrição",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(animal.descricao, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            // Botão de ação
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // aqui pode colocar ação de contato/compartilhar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Ação do botão aqui")),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text(
                  "Compartilhar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyan),
          const SizedBox(width: 10),
          Expanded(
            child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';

class TelaDetalhesAnimal extends StatelessWidget {
  final Animal animal;

  const TelaDetalhesAnimal({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(animal.nome), backgroundColor: Colors.cyan),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(animal.imagem),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text("Raça: ${animal.raca}", style: const TextStyle(fontSize: 16)),
            Text("Cor: ${animal.cor}", style: const TextStyle(fontSize: 16)),
            Text(
              "Espécie: ${animal.especie}",
              style: const TextStyle(fontSize: 16),
            ),
            Text("Sexo: ${animal.sexo}", style: const TextStyle(fontSize: 16)),
            Text(
              "Último Local: ${animal.ultimoLocal}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Cidade: ${animal.cidade}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Bairro: ${animal.bairro}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Endereço: ${animal.endereco}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Data do Desaparecimento: ${animal.dataDesaparecimento}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Descrição:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(animal.descricao),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'animal.dart';

class TelaDetalhesAnimal extends StatefulWidget {
  final Animal animal;

  const TelaDetalhesAnimal({super.key, required this.animal});

  @override
  State<TelaDetalhesAnimal> createState() => _TelaDetalhesAnimalState();
}

class _TelaDetalhesAnimalState extends State<TelaDetalhesAnimal> {
  int _indiceImagemAtual = 0;

  void _proximaImagem() {
    setState(() {
      _indiceImagemAtual =
          (_indiceImagemAtual + 1) % widget.animal.imagens.length;
    });
  }

  void _imagemAnterior() {
    setState(() {
      _indiceImagemAtual =
          (_indiceImagemAtual - 1) % widget.animal.imagens.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final temMultiplasImagens = widget.animal.imagens.length > 1;
    final imagemAtual = widget.animal.imagens[_indiceImagemAtual];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.animal.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carrossel de imagens
            Stack(
              children: [
                // Imagem principal
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(imagemAtual),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),

                // Indicador de múltiplas imagens
                if (temMultiplasImagens) ...[
                  // Contador de imagens
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_indiceImagemAtual + 1}/${widget.animal.imagens.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Botão anterior
                  Positioned(
                    left: 12,
                    top: 110,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, size: 32),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: _imagemAnterior,
                    ),
                  ),

                  // Botão próximo
                  Positioned(
                    right: 12,
                    top: 110,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, size: 32),
                      color: Colors.white,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: _proximaImagem,
                    ),
                  ),
                ],
              ],
            ),

            // Miniaturas das imagens (se tiver mais de uma)
            if (temMultiplasImagens) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.animal.imagens.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _indiceImagemAtual = index;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _indiceImagemAtual == index
                                ? Colors.blue[700]!
                                : Colors.grey.shade300,
                            width: _indiceImagemAtual == index ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(widget.animal.imagens[index]),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Informações em cards
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(Icons.pets, "Raça", widget.animal.raca),
                    _infoRow(Icons.color_lens, "Cor", widget.animal.cor),
                    _infoRow(Icons.category, "Espécie", widget.animal.especie),
                    _infoRow(Icons.male, "Sexo", widget.animal.sexo),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.place,
                      "Último Local",
                      widget.animal.ultimoLocal,
                    ),
                    _infoRow(
                      Icons.location_city,
                      "Cidade",
                      widget.animal.cidade,
                    ),
                    _infoRow(Icons.map, "Bairro", widget.animal.bairro),
                    _infoRow(Icons.home, "Endereço", widget.animal.endereco),
                    _infoRow(
                      Icons.calendar_today,
                      "Data do Desaparecimento",
                      widget.animal.dataDesaparecimento,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Descrição",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.animal.descricao,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Ação de compartilhar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Compartilhando informações..."),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text(
                      "Compartilhar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Ação de contato
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Entrando em contato..."),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text(
                      "Contatar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[700], size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

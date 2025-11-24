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
      _indiceImagemAtual = (_indiceImagemAtual - 1) < 0
          ? widget.animal.imagens.length - 1
          : _indiceImagemAtual - 1;
    });
  }

  Widget _construirImagem(String caminhoImagem) {
    print('🖼️ Carregando imagem: $caminhoImagem');

    if (caminhoImagem.startsWith('http')) {
      // ✅ IMAGENS DA INTERNET (Laravel)
      return Image.network(
        caminhoImagem,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[200],
            height: 250,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('❌ Erro ao carregar imagem: $error');
          return Container(
            color: Colors.grey[200],
            height: 250,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 50, color: Colors.red),
                SizedBox(height: 8),
                Text(
                  'Erro ao carregar imagem',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        },
      );
    } else if (caminhoImagem.startsWith('assets/')) {
      // ✅ IMAGENS LOCAIS (assets)
      return Image.asset(
        caminhoImagem,
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            height: 250,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text('Imagem não encontrada'),
              ],
            ),
          );
        },
      );
    } else {
      // ✅ ARQUIVOS LOCAIS (File)
      return Image.file(
        File(caminhoImagem),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            height: 250,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 60, color: Colors.grey),
                SizedBox(height: 8),
                Text('Arquivo não encontrado'),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // DEBUG - Verifique os dados recebidos
    print('🎯 TELA DETALHES - Dados do animal:');
    print('   Nome: ${widget.animal.nome}');
    print('   Imagens: ${widget.animal.imagens}');
    print('   Quantidade: ${widget.animal.imagens.length}');
    print(
      '   Primeira imagem: ${widget.animal.imagens.isNotEmpty ? widget.animal.imagens[0] : "VAZIO"}',
    );

    final temMultiplasImagens = widget.animal.imagens.length > 1;
    final imagemAtual = widget.animal.imagens.isNotEmpty
        ? widget.animal.imagens[_indiceImagemAtual]
        : 'assets/cachorro1.png'; // Fallback
    final corPrincipal = widget.animal.isPerdido
        ? Colors.blue[700]!
        : Colors.green[700]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.animal.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BADGE DE STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: widget.animal.isPerdido
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.animal.isPerdido
                            ? Colors.red
                            : Colors.green,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      widget.animal.isPerdido
                          ? '🐕 ANIMAL PERDIDO'
                          : '🔍 ANIMAL ENCONTRADO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: widget.animal.isPerdido
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Carrossel de imagens
            Stack(
              children: [
                // Imagem principal
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _construirImagem(imagemAtual),
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
                                ? corPrincipal
                                : Colors.grey.shade300,
                            width: _indiceImagemAtual == index ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            widget.animal.imagens[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.error_outline,
                                  size: 20,
                                  color: Colors.red,
                                ),
                              );
                            },
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
                    if (widget.animal.isEncontrado &&
                        widget.animal.situacaoSaude != null &&
                        widget.animal.situacaoSaude!.isNotEmpty)
                      _infoRow(
                        Icons.medical_services,
                        "Situação de Saúde",
                        widget.animal.situacaoSaude!,
                      ),
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
                    if (widget.animal.isPerdido) ...[
                      _infoRow(
                        Icons.place,
                        "Último Local Visto",
                        widget.animal.ultimoLocalVisto ?? 'Não informado',
                      ),
                      _infoRow(
                        Icons.home,
                        "Endereço do Desaparecimento",
                        widget.animal.enderecoDesaparecimento ??
                            'Não informado',
                      ),
                      _infoRow(
                        Icons.calendar_today,
                        "Data do Desaparecimento",
                        widget.animal.dataDesaparecimento ?? 'Não informada',
                      ),
                    ] else ...[
                      _infoRow(
                        Icons.place,
                        "Local do Encontro",
                        widget.animal.localEncontro ?? 'Não informado',
                      ),
                      _infoRow(
                        Icons.home,
                        "Endereço do Encontro",
                        widget.animal.enderecoEncontro ?? 'Não informado',
                      ),
                      _infoRow(
                        Icons.calendar_today,
                        "Data do Encontro",
                        widget.animal.dataEncontro ?? 'Não informada',
                      ),
                    ],
                    _infoRow(
                      Icons.location_city,
                      "Cidade",
                      widget.animal.cidade,
                    ),
                    _infoRow(Icons.map, "Bairro", widget.animal.bairro),
                  ],
                ),
              ),
            ),

            // CARD DE CONTATO
            if (widget.animal.userTelefone != null &&
                widget.animal.userTelefone!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, color: corPrincipal, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            widget.animal.isEncontrado
                                ? "Contato do Responsável"
                                : "Contato do Dono",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.animal.userTelefone!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 56, 142, 60),
                        ),
                      ),
                      if (widget.animal.userNome != null &&
                          widget.animal.userNome!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          "Responsável: ${widget.animal.userNome!}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // OBSERVAÇÕES
            const Text(
              "Observações",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                widget.animal.descricao.isNotEmpty
                    ? widget.animal.descricao
                    : 'Nenhuma observação fornecida',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botão de voltar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: corPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "VOLTAR",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    final corPrincipal = widget.animal.isPerdido
        ? Colors.blue[700]!
        : Colors.green[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: corPrincipal, size: 22),
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

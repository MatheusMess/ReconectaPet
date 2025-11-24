import 'package:flutter/material.dart';

class TesteImagemScreen extends StatelessWidget {
  final List<String> imagensTeste = [
    '7I5V8dZGQm1wAgsYOEEIVdmYbjuWsB4mwZ0Frhma.png',
    'o1Q2ZAAU8QPqh9mu2fSrIQybVOetiFRau5b04EfD.jpg',
    'feFXnbZ8MxbN4K1mvAzLdAafirXV4LcNjGIusOv0.png',
    'pDyYZCaCRJqLgXAec1cQRbpx2HtLxFMW59pN2Abt.jpg',
    'h0Do49rMox2HJajPPcIQH0gNcy3OTPRvrXv5pnfL.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Imagens do Laravel'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: imagensTeste.length,
        itemBuilder: (context, index) {
          return _buildImageCard(imagensTeste[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Teste rápido com a primeira imagem
          _testeRapido(context);
        },
        child: Icon(Icons.image_search),
        tooltip: 'Teste Rápido',
      ),
    );
  }

  Widget _buildImageCard(String filename) {
    final url = 'http://192.168.15.16:8000/storage/animais/$filename';

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arquivo: $filename',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text(
                          'Carregando...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Erro ao carregar',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Text(
              'URL: $url',
              style: TextStyle(fontSize: 10, color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _testeRapido(BuildContext context) {
    final url = 'http://192.168.15.16:8000/storage/animais/${imagensTeste[0]}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Teste Rápido'),
        content: Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, size: 50, color: Colors.orange),
                        SizedBox(height: 16),
                        Text(
                          'Sem conexão\nou URL inválida',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                imagensTeste[0],
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

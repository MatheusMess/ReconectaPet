import 'dart:math';
import 'package:flutter/material.dart';

class FundoPatinhaAleatoria extends StatelessWidget {
  final List<String> tileAssetPaths;
  final double tileWidth;
  final double tileHeight;
  final double espacamento;
  final double? anguloFixo;
  final bool anguloAleatorio;
  final double opacidade;
<<<<<<< HEAD
  final double escalaPatinha; // 🔹 novo
=======
  final double escalaPatinha;
>>>>>>> f7ca8a5306a1afee2ed8ba2e57e75633d517d34c
  final List<Widget> stackChildren;

  const FundoPatinhaAleatoria({
    super.key,
    required this.tileAssetPaths,
    required this.tileWidth,
    required this.tileHeight,
    this.espacamento = 50,
    this.anguloFixo,
    this.anguloAleatorio = true,
    this.opacidade = 0.08,
    this.escalaPatinha = 0.6,
    this.stackChildren = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columnCount =
            (constraints.maxWidth / (tileWidth + espacamento)).ceil();
        final int rowCount =
            (constraints.maxHeight / (tileHeight + espacamento)).ceil();

        final Random random = Random();

        return Stack(
          children: [
            // fundo colorido
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              color: const Color(0xFF10C4E4), // cor #10c4e4
            ),

            // patinhas aleatórias
            ...List.generate(rowCount * columnCount, (int index) {
              final int row = index ~/ columnCount;
              final int col = index % columnCount;

              final double angulo = anguloAleatorio
                  ? random.nextDouble() * pi
                  : (anguloFixo != null ? anguloFixo! * pi / 180 : 0);

              return Positioned(
                left: col * (tileWidth + espacamento),
                top: row * (tileHeight + espacamento),
                width: tileWidth,
                height: tileHeight,
                child: Transform.rotate(
                  angle: angulo,
                  child: Transform.scale(
                    scale: escalaPatinha, // 🔹 aplica a escala
                    child: Opacity(
                      opacity: opacidade,
                      child: Image.asset(
                        tileAssetPaths[random.nextInt(tileAssetPaths.length)],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            }),
            ...stackChildren,
          ],
        );
      },
    );
  }
}

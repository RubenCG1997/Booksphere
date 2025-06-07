import 'package:booksphere/core/color.dart';
import 'package:flutter/material.dart';

/// Widget que muestra una línea divisoria horizontal con un título centrado.
///
/// Las líneas se ajustan a un ancho proporcional al tamaño de la pantalla.
class DividingLines extends StatelessWidget {
  /// Título que se muestra en el centro de las líneas divisorias.
  final String title;

  const DividingLines({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Ancho fijo para las líneas, igual al 25% del ancho total de la pantalla
    final lineWidth = size.width * 0.25;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Línea izquierda
        Container(
          width: lineWidth,
          height: 1,
          color: AppColor.dividerColor,
        ),

        // Título centrado
        Text(
          title,
          style: TextStyle(
            color: const Color.fromARGB(128, 255, 255, 255), // Blanco semi-transparente
            fontSize: 12,
            fontFamily: 'Merriweather',
          ),
        ),

        // Línea derecha
        Container(
          width: lineWidth,
          height: 1,
          color: AppColor.dividerColor,
        ),
      ],
    );
  }
}

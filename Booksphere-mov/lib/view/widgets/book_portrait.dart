import 'package:flutter/material.dart';

import '../../core/color.dart';

/// Widget que muestra la portada de un libro a partir de una URL de imagen.
///
/// Si la URL está vacía, muestra un widget vacío centrado.
class BookPortrait extends StatelessWidget {
  /// URL de la imagen de la portada del libro.
  final String urlImg;

  /// Constructor que requiere la [urlImg].
  const BookPortrait({super.key, required this.urlImg});

  @override
  Widget build(BuildContext context) {
    // Si la URL está vacía, retorna un widget vacío centrado.
    if (urlImg.isEmpty) {
      return Center();
    }

    // Muestra la imagen desde la URL con ajuste para mantener la altura.
    return Image.network(urlImg, fit: BoxFit.fitHeight);
  }
}

import 'package:flutter/material.dart';

/// Widget que muestra el icono de la aplicación desde los assets.
/// La imagen se carga desde 'assets/images/icon.png' con un ancho fijo de 100.
class ImageApp extends StatelessWidget {
  const ImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/icon.png',
      width: 100,
    );
  }
}

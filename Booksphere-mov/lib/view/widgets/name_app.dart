import 'package:flutter/material.dart';

import '../../core/styles.dart';

// Widget sin estado que muestra el nombre de la aplicación con un estilo personalizado
class NameApp extends StatelessWidget {
  const NameApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retorna un texto con el nombre de la app usando un estilo definido en Styles
    return Text('Booksphere', style: Styles.customHeaderTextStyle);
  }
}

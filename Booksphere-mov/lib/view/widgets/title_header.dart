import 'package:flutter/material.dart';

import '../../core/styles.dart';

/// Widget que muestra un título con estilo personalizado para encabezados.
///
/// Recibe un [title] que será el texto a mostrar.
class TitleHeader extends StatelessWidget {
  /// Texto que se mostrará como encabezado.
  final String title;

  /// Constructor que requiere el título a mostrar.
  const TitleHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Styles.customTitleHeaderTextStyle,
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/color.dart';

/// Línea divisoria horizontal que se extiende a lo ancho de la pantalla.
///
/// Utiliza un color definido en la app para el divisor.
class DividingLastLine extends StatelessWidget {
  const DividingLastLine({super.key});

  /// Construye un contenedor con altura 1 y ancho igual al ancho de pantalla.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 1,
      color: AppColor.dividerColor,
    );
  }
}

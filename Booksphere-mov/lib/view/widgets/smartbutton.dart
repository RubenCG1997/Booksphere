import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../core/styles.dart';

/// Botón personalizado con estilo específico y texto configurable.
///
/// Recibe un [title] para mostrar como texto y un callback opcional [onPressed].
class SmartButton extends StatefulWidget {
  /// Texto que se mostrará en el botón.
  final String title;

  /// Función que se ejecuta al presionar el botón.
  final VoidCallback? onPressed;

  /// Constructor para el botón, con título requerido y callback opcional.
  const SmartButton({super.key, required this.title, this.onPressed});

  @override
  State<SmartButton> createState() => _SmartButtonState();
}

class _SmartButtonState extends State<SmartButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      /// Estilo personalizado para el botón, usando colores y formas definidos.
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.smartButtonColor,
        shape: Styles.customButtonShape,
      ),

      /// Callback al presionar, puede ser nulo.
      onPressed: widget.onPressed,

      /// Texto del botón con estilo personalizado.
      child: Text(widget.title, style: Styles.customSmartButtonTextStyle),
    );
  }
}

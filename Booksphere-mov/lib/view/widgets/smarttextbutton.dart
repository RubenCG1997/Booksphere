import 'package:flutter/material.dart';
import '../../core/styles.dart';

/// Botón de texto personalizado con estilo configurable.
///
/// Recibe un [title] para mostrar como texto y un callback opcional [onPressed].
class SmartTextbutton extends StatefulWidget {
  /// Texto que se mostrará en el botón.
  final String title;

  /// Función que se ejecuta al presionar el botón.
  final VoidCallback? onPressed;

  /// Constructor del botón con título requerido y callback opcional.
  const SmartTextbutton({super.key, required this.title, this.onPressed});

  @override
  State<SmartTextbutton> createState() => _SmartTextbuttonState();
}

class _SmartTextbuttonState extends State<SmartTextbutton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      /// Callback que se ejecuta al presionar el botón.
      onPressed: widget.onPressed,

      /// Texto del botón con estilo personalizado.
      child: Text(widget.title, style: Styles.customSmartTextButtonTextStyle),
    );
  }
}

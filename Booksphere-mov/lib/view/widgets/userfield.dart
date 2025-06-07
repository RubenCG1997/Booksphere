import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/color.dart';
import '../../core/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Campo de texto personalizado para ingresar el nombre de usuario.
///
/// Limita el texto a un máximo de 25 caracteres y muestra una pista
/// de ayuda con un `SnackBar` al presionar el ícono de información.
class Userfield extends StatefulWidget {
  /// Controlador del campo de texto.
  final TextEditingController controller;

  /// Constructor que recibe un [TextEditingController] requerido.
  const Userfield({super.key, required this.controller});

  @override
  State<Userfield> createState() => _UserfieldState();
}

class _UserfieldState extends State<Userfield> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      controller: widget.controller,
      style: Styles.customTextFieldStyle,
      inputFormatters: [LengthLimitingTextInputFormatter(25)],
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColor.hintColor, size: 15),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  loc.userFieldHint,
                ),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        enabledBorder: Styles.customOutlineInputBorder,
        focusedBorder: Styles.customOutlineInputBorder,
        labelText: loc.userFieldLabel,
        labelStyle: Styles.customHintTextStyle,
      ),
    );
  }
}

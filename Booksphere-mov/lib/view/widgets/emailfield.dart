import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../core/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Campo de texto para introducir el correo electrónico con estilo personalizado.
/// Incluye un icono de información que muestra un tooltip en un Snackbar.
class Emailfield extends StatefulWidget {
  /// Controlador del campo de texto para manejar el valor del email
  final TextEditingController controller;

  const Emailfield({super.key, required this.controller});

  @override
  State<Emailfield> createState() => _EmailfieldState();
}

class _EmailfieldState extends State<Emailfield> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      controller: widget.controller,
      style: Styles.customTextFieldStyle, // Estilo del texto escrito
      decoration: InputDecoration(
        // Icono a la derecha para mostrar información adicional
        suffixIcon: IconButton(
          icon: Icon(Icons.info_outline, color: AppColor.hintColor, size: 15),
          onPressed: () {
            // Muestra un snackbar con información sobre el formato del correo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  loc.emailInfoTooltip,
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        // Bordes personalizados para los estados habilitado y enfocado
        enabledBorder: Styles.customOutlineInputBorder,
        focusedBorder: Styles.customOutlineInputBorder,
        labelText: loc.emailLabel, // Etiqueta para el campo de texto,
        labelStyle: Styles.customHintTextStyle,
      ),
      keyboardType: TextInputType.emailAddress, // Optimiza teclado para email
      autofillHints: const [AutofillHints.email], // Sugerencias de autofill
      validator: (value) {
        // Validación básica del email (opcional)
        if (value == null || value.isEmpty) {
          return loc.emailEmptyError ;
        }
        if (!value.contains('@') || !value.contains('.')) {
          return loc.emailInvalidError;
        }
        return null;
      },
    );
  }
}

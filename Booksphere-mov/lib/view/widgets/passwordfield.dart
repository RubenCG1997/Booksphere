import 'package:booksphere/core/color.dart';
import 'package:flutter/material.dart';
import '../../core/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Un widget que muestra un campo de texto para ingresar contraseñas,
/// permitiendo alternar la visibilidad del texto y ver sugerencias.
class PasswordField extends StatefulWidget {
  /// Controlador para acceder y modificar el texto del campo.
  final TextEditingController controller;

  /// Constructor que requiere un controlador para el campo.
  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  /// Determina si el texto del campo está oculto (contraseña).
  bool _isObscure = true;

  /// Cambia el estado de visibilidad de la contraseña.
  void togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  /// Muestra una sugerencia al usuario sobre la longitud de la contraseña.
  void showPasswordInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.passwordInfoTooltip),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      style: Styles.customTextFieldStyle,
      decoration: InputDecoration(
        labelText: loc.passwordLabel,
        labelStyle: Styles.customHintTextStyle,
        enabledBorder: Styles.customOutlineInputBorder,
        focusedBorder: Styles.customOutlineInputBorder,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            /// Icono de ayuda sobre la contraseña.
            IconButton(
              icon: Icon(
                Icons.info_outline,
                color: AppColor.hintColor,
                size: 15,
              ),
              onPressed: () => showPasswordInfo(context),
            ),

            /// Icono para alternar visibilidad de la contraseña.
            IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: AppColor.hintColor,
                size: 15,
              ),
              onPressed: togglePasswordVisibility,
            ),
          ],
        ),
      ),
    );
  }
}

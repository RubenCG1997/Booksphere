import 'package:booksphere/core/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../controller/user_controller.dart';
import '../../core/styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Botón flotante personalizado para iniciar sesión con Google.
///
/// Al presionar, realiza el proceso de autenticación con Google.
/// En caso de éxito, muestra un mensaje y redirige a la pantalla principal.
class ButtonGoogle extends StatefulWidget {
  const ButtonGoogle({super.key});

  @override
  State<ButtonGoogle> createState() => _ButtonGoogleState();
}

class _ButtonGoogleState extends State<ButtonGoogle> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return FloatingActionButton(
      backgroundColor: AppColor.googleButtonColor,
      shape: Styles.customButtonShape,
      onPressed: () async {
        // Intentar iniciar sesión con Google mediante UserController.
        String? uidUser = await UserController().signInWithGoogle();

        if (uidUser != null) {
          // Mostrar mensaje de éxito.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.googleSignInSuccess),
              backgroundColor: Colors.green,
            ),
          );
          // Navegar a la ruta '/home' enviando el uid del usuario.
          context.go('/home', extra: uidUser);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de Google.
          Image.asset('assets/images/google.png', width: 40),
          const SizedBox(width: 10),
          // Texto del botón.
          Text(loc.googleSignInButton, style: Styles.googleButtonTextStyle),
        ],
      ),
    );
  }
}

import 'package:booksphere/view/widgets/dividing_last_line.dart';
import 'package:booksphere/view/widgets/emailfield.dart';
import 'package:booksphere/view/widgets/image_app.dart';
import 'package:booksphere/view/widgets/name_app.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:booksphere/view/widgets/smarttextbutton.dart';
import 'package:booksphere/view/widgets/title_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/user_controller.dart';
import '../core/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla para recuperación de contraseña.
///
/// Permite al usuario ingresar su correo electrónico para recibir un enlace
/// de restablecimiento de contraseña.
class RecoverPassword extends StatefulWidget {
  const RecoverPassword({super.key});

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  /// Controlador del campo de correo electrónico.
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.backgroundColor,
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                /// Logo y nombre de la app
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [NameApp(), ImageApp()],
                ),
                const SizedBox(height: 10),

                /// Título principal
                TitleHeader(title: loc.recoverTitle),
                const SizedBox(height: 10),

                /// Campo de entrada de email
                SizedBox(
                  width: size.width,
                  child: Emailfield(controller: _emailController),
                ),
                const SizedBox(height: 10),

                /// Botón para enviar correo de recuperación
                SizedBox(
                  width: size.width,
                  child: SmartButton(
                    title: loc.sendButton,
                    onPressed: () {
                      final email = _emailController.text;

                      if (email.isEmpty) {
                        // Validación: campo vacío
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.emailEmptyError),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      } else if (!RegExp(
                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(email)) {
                        // Validación: formato de correo inválido
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.emailInvalidError),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      } else {
                        // Enviar solicitud de recuperación
                        UserController().recoverPassword(email);

                        // Mostrar mensaje de éxito
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.emailSentSuccess),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 1),
                          ),
                        );

                        // Redirigir a pantalla de login
                        context.go('/Login');
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                /// Línea divisoria decorativa
                DividingLastLine(),

                /// Botón de volver
                SmartTextbutton(
                  title: loc.goBack,
                  onPressed: () => context.go('/Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

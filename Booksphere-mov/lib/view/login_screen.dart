import 'package:booksphere/controller/user_controller.dart';
import 'package:booksphere/view/widgets/button_google.dart';
import 'package:booksphere/view/widgets/dividing_last_line.dart';
import 'package:booksphere/view/widgets/dividing_lines.dart';
import 'package:booksphere/view/widgets/emailfield.dart';
import 'package:booksphere/view/widgets/image_app.dart';
import 'package:booksphere/view/widgets/name_app.dart';
import 'package:booksphere/view/widgets/passwordfield.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:booksphere/view/widgets/smarttextbutton.dart';
import 'package:booksphere/view/widgets/title_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/color.dart';
/// Pantalla de inicio de sesión para el usuario.
///
/// Permite iniciar sesión mediante Google o con credenciales (email y contraseña).
/// También ofrece opciones para recuperar la contraseña o ir al registro.
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

/// Estado mutable del widget [Login].
///
/// Contiene controladores de texto, validación básica y lógica de navegación.
class _LoginState extends State<Login> {
  /// Controlador del campo de correo electrónico.
  final TextEditingController _emailController = TextEditingController();

  /// Controlador del campo de contraseña.
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColor.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  // Nombre y logo de la app
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [NameApp(), ImageApp()],
                  ),
                  const SizedBox(height: 10),

                  // Título principal
                  TitleHeader(title: loc.loginTitle),
                  const SizedBox(height: 10),

                  // Línea divisoria para login con Google
                  SizedBox(
                    width: size.width,
                    child: DividingLines(title: loc.accessDirect),
                  ),
                  const SizedBox(height: 5),

                  // Botón de Google
                  SizedBox(width: size.width, child: ButtonGoogle()),
                  const SizedBox(height: 5),

                  // Línea divisoria para login con email
                  SizedBox(
                    width: size.width,
                    child: DividingLines(title: loc.accessEmail),
                  ),
                  const SizedBox(height: 10),

                  // Campo de email
                  SizedBox(
                    width: size.width,
                    child: Emailfield(controller: _emailController),
                  ),
                  const SizedBox(height: 10),

                  // Campo de contraseña
                  SizedBox(
                    width: size.width,
                    child: PasswordField(controller: _passwordController),
                  ),

                  // Botón para recuperar contraseña
                  SizedBox(
                    width: size.width,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SmartTextbutton(
                        title: loc.forgotPassword,
                        onPressed: () => context.go('/recover_password'),
                      ),
                    ),
                  ),

                  // Botón principal de login
                  SizedBox(
                    width: size.width,
                    child: SmartButton(
                      title: loc.loginButton,
                      onPressed: () async {
                        if (_emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          String? uidUser = await UserController().login(
                            _emailController.text,
                            _passwordController.text,
                            context,
                          );
                          if (uidUser != null) {
                            context.go('/home', extra: uidUser);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              Text(loc.fillAllFields),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Línea divisoria final
                  DividingLastLine(),

                  // Botón para registro de nuevo usuario
                  SizedBox(
                    width: size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: SmartTextbutton(
                        title: loc.noAccountText,
                        onPressed: () => context.go('/register'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:booksphere/view/widgets/image_app.dart';
import 'package:booksphere/view/widgets/name_app.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:booksphere/view/widgets/smarttextbutton.dart';
import '../core/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla de bienvenida de la aplicación.
///
/// Muestra:
/// - Un grid con imágenes decorativas.
/// - Logo de la app.
/// - Nombre de la app.
/// - Botón para iniciar sesión.
/// - Botón para registrarse.
class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          color: AppColor.backgroundColor,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              /// Grid decorativo de 2 columnas con 6 imágenes
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(6, (index) {
                    return Image.asset(
                      'assets/images/A_mi_madre-Rosalia_de_Castro-md.png',
                      fit: BoxFit.contain,
                    );
                  }),
                ),
              ),

              /// Logo de la app
              const ImageApp(),

              /// Nombre de la app
              const NameApp(),

              const SizedBox(height: 10),

              /// Botón para navegar a la pantalla de inicio de sesión
              SizedBox(
                width: double.infinity,
                child: SmartButton(
                  title: AppLocalizations.of(context)!.loginButton,
                  onPressed: () => context.go('/Login'),
                ),
              ),

              /// Texto con enlace para registrarse
              SmartTextbutton(
                title: AppLocalizations.of(context)!.noAccountText,
                onPressed: () => context.go('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Punto de entrada principal de la aplicación.
/// Inicializa Firebase, configura la orientación y ejecuta la app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializa Firebase con opciones específicas de la plataforma actual.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Fuerza la orientación de la app solo en vertical (portraitUp).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// Ejecuta la aplicación principal.
  runApp(const MyApp());
}

/// Widget raíz de la aplicación.
/// Configura MaterialApp con rutas, localización y comportamiento de scroll personalizado.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      /// Configura el comportamiento del scroll para soportar touch y mouse.
      scrollBehavior: AppScrollBehavior(),

      /// Título de la aplicación.
      title: 'Booksphere',

      /// Delegados de localización para soportar múltiples idiomas.
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Idiomas soportados, proporcionados por el delegado generado.
      supportedLocales: AppLocalizations.supportedLocales,

      /// Esta función decide qué locale usar basado en el dispositivo.
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first; // Por defecto, si no coincide
      },

      /// Configuración de rutas para navegación.
      routerConfig: appRouter,
    );
  }
}

/// Comportamiento personalizado de scroll que permite desplazamiento
/// por touch (pantalla táctil) y mouse (ordenador).
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

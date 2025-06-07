import 'package:flutter/material.dart';

/// Clase que contiene los colores usados en la aplicación.
///
/// Los colores están definidos con valores ARGB fijos para mantener
/// consistencia visual en toda la app.
class AppColor {
  /// Color de fondo principal de la app.
  static const Color backgroundColor = Color.fromARGB(255, 160, 20, 35);

  /// Color principal para texto (blanco).
  static const Color textColor = Color.fromARGB(255, 255, 255, 255);

  /// Color para botones inteligentes (smart buttons).
  static const Color smartButtonColor = Color.fromARGB(255, 208, 135, 145);

  /// Color para botones de Google (generalmente fondo blanco).
  static const Color googleButtonColor = Color.fromARGB(255, 255, 255, 255);

  /// Color del texto dentro de botones de Google (negro).
  static const Color textGoogleColor = Color.fromARGB(255, 0, 0, 0);

  /// Color para sombras generales (negro sólido).
  static const Color shadowColor = Color.fromARGB(255, 0, 0, 0);

  /// Color para sombras en modo retrato (más transparente).
  static const Color shadowPortraitColor = Color.fromARGB(65, 0, 0, 0);

  /// Color para divisores o separadores (blanco semi-transparente).
  static const Color dividerColor = Color.fromARGB(128, 255, 255, 255);

  /// Color para hints o texto placeholder (blanco semi-transparente).
  static const Color hintColor = Color.fromARGB(128, 255, 255, 255);

  /// Color usado para elementos deshabilitados.
  static const Color disableColor = Colors.grey;

  /// Color para el borde de inputs (blanco sólido).
  static const Color outlineInputColor = Color.fromARGB(255, 255, 255, 255);

  /// Color para barras o elementos destacados (rojo oscuro).
  static const Color barColor = Color.fromARGB(255, 96, 12, 21);
}

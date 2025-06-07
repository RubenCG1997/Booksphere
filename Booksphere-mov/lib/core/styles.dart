import 'package:flutter/material.dart';

import 'color.dart';

/// Clase que contiene estilos reutilizables para textos, botones y decoraciones
/// en la aplicación, centralizando la configuración de colores, fuentes y
/// formas para mantener coherencia visual.
class Styles {
  /// Texto para botones inteligentes con color de texto personalizado,
  /// tamaño de 16 y fuente 'Merriweather'.
  static TextStyle customSmartButtonTextStyle = TextStyle(
    color: AppColor.textColor,
    fontSize: 16,
    fontFamily: 'Merriweather',
  );

  /// Texto para botones de texto subrayado, con color personalizado,
  /// tamaño 12 y decoración de subrayado.
  static TextStyle customSmartTextButtonTextStyle = TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: AppColor.textColor,
    decorationThickness: 1,
    color: AppColor.textColor,
    fontSize: 12,
  );

  /// Forma personalizada para botones, con bordes redondeados de radio 8.
  static OutlinedBorder customButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  );

  /// Texto grande para encabezados con sombra, tamaño 30, color personalizado
  /// y fuente 'Merriweather'.
  static TextStyle customHeaderTextStyle = TextStyle(
    color: AppColor.textColor,
    fontSize: 30,
    fontFamily: 'Merriweather',
    shadows: [customShadowHeader],
  );

  /// Sombra usada en encabezados para dar profundidad al texto.
  static Shadow customShadowHeader = Shadow(
    blurRadius: 10.0,
    color: AppColor.shadowColor,
    offset: Offset(0.0, 4.0),
  );

  /// Texto pequeño para títulos de encabezado con fuente y color definidos.
  static TextStyle customTitleHeaderTextStyle = TextStyle(
    color: AppColor.textColor,
    fontSize: 14,
    fontFamily: 'Merriweather',
  );

  /// Texto para botones de Google, con fuente 'Merriweather', tamaño 14
  /// y color de texto personalizado.
  static TextStyle googleButtonTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'Merriweather',
    color: AppColor.textGoogleColor,
  );

  /// Estilo de texto para campos de texto con color y fuente personalizados.
  static TextStyle customTextFieldStyle = TextStyle(
    color: AppColor.textColor,
    fontSize: 14,
    fontFamily: 'Merriweather',
  );

  /// Estilo de texto para los hints (placeholders) de campos de texto,
  /// con color translúcido para distinguirlos del texto normal.
  static TextStyle customHintTextStyle = TextStyle(
    color: AppColor.hintColor,
    fontSize: 14,
    fontFamily: 'Merriweather',
  );

  /// Borde personalizado para campos de texto con color blanco definido.
  static OutlineInputBorder customOutlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColor.outlineInputColor),
  );

  /// Borde personalizado para campos de texto en estado de error,
  /// con el mismo color que el borde normal.
  static OutlineInputBorder customErrorOutlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColor.outlineInputColor),
  );

  /// Decoración para contenedores, con borde blanco y radio de borde 8.
  static BoxDecoration customBoxDecoration = BoxDecoration(
    border: Border.all(color: AppColor.outlineInputColor, width: 2),
    borderRadius: BorderRadius.circular(8),
  );

  /// Estilo de texto para barras (AppBar, TabBar) con color blanco,
  /// tamaño 18 y fuente 'Merriweather'.
  static TextStyle customBarTextStyle = TextStyle(
    color: AppColor.textColor,
    fontSize: 18,
    fontFamily: 'Merriweather',
  );
}

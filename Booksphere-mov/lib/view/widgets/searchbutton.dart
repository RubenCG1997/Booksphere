import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/color.dart';

/// Botón que navega a la pantalla de búsqueda pasando el UID del usuario.
class Searchbutton extends StatelessWidget {
  /// Identificador único del usuario, que se pasa como parámetro en la navegación.
  final String uid;

  /// Constructor del botón, requiere el [uid].
  const Searchbutton({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      /// Al presionar, navega a la ruta '/search' enviando el UID como parámetro.
      onPressed: () {
        context.push('/search', extra: uid);
      },

      /// Icono de lupa con tamaño y color personalizado.
      icon: Icon(Icons.search, color: AppColor.textColor, size: 30),
    );
  }
}

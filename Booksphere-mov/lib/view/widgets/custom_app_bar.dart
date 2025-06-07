import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/color.dart';

/// AppBar personalizado con color de fondo definido en la app.
///
/// Implementa [PreferredSizeWidget] para definir su tamaño estándar.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  /// Tamaño preferido del AppBar, igual al alto estándar de la barra de herramientas.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Construye el widget AppBar con color de fondo personalizado.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.backgroundColor,
    );
  }
}

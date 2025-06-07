import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Botón elevado circular que, al presionarlo, hace pop en la navegación
/// y devuelve el string `'delete'` como resultado.
class ElevatedPop extends StatelessWidget {
  const ElevatedPop({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navega hacia atrás enviando 'delete' como resultado
        context.pop('delete');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      // Icono dentro del botón: imagen cruz
      child: Image.asset(
        'assets/images/cross.png',
        width: 25,
        height: 25,
      ),
    );
  }
}

import 'package:booksphere/view/tab/mylistTab.dart';
import 'package:booksphere/view/tab/profileTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../core/color.dart';
import 'tab/homeTab.dart';

/// Pantalla principal que contiene la navegación entre pestañas.
///
/// Muestra tres pestañas: Inicio, Mis listas y Perfil, y permite
/// cambiar entre ellas mediante una barra de navegación inferior.
class Home extends StatefulWidget {
  /// Identificador del usuario actual, usado para cargar datos personalizados.
  final String? uid;

  /// Crea una instancia de [Home] con el UID del usuario.
  const Home({super.key, required this.uid});

  @override
  State<Home> createState() => _HomeState();
}

/// Estado mutable de la pantalla principal [Home].
///
/// Maneja el índice de la pestaña seleccionada y la lista de páginas.
class _HomeState extends State<Home> {
  /// Índice de la pestaña actualmente seleccionada.
  late int _index;

  /// Lista de widgets que representan cada pestaña.
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Inicializa la pestaña seleccionada en la primera (Inicio).
    _index = 0;

    // Define las páginas correspondientes a cada pestaña,
    // pasando el UID para personalización.
    _pages = [
      Hometab(uid: widget.uid),
      Mylisttab(uid: widget.uid),
      Profiletab(uid: widget.uid),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      // Barra de navegación inferior con íconos y etiquetas.
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: loc.home),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: loc.myLists,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: loc.profile),
        ],
        selectedItemColor: AppColor.textColor,
        unselectedItemColor: AppColor.hintColor,
        backgroundColor: AppColor.barColor,
        currentIndex: _index,
        onTap: (index) {
          // Actualiza el estado para cambiar la pestaña visible.
          setState(() {
            _index = index;
          });
        },
      ),
      // Muestra el contenido de la pestaña seleccionada.
      body: _pages[_index],
    );
  }
}

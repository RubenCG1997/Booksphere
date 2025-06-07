import 'package:booksphere/controller/user_controller.dart';
import 'package:booksphere/view/widgets/book_pageview.dart';
import 'package:booksphere/view/widgets/carrousel_home.dart';
import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../core/styles.dart';
import '../widgets/searchbutton.dart';
import '../../controller/book_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget principal que representa la pestaña de inicio (Home).
///
/// Muestra:
/// - Nombre del usuario.
/// - Top 3 libros mejor valorados.
/// - Carrusel de libros recientes.
/// - Carruseles por género obtenidos dinámicamente.
///
/// Parámetro requerido:
/// - [uid]: ID único del usuario actual.
class Hometab extends StatefulWidget {
  final String? uid;

  /// Constructor que recibe el [uid] del usuario.
  const Hometab({super.key, required this.uid});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  String username = 'Cargando...';
  List<String> genres = [];

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadGenres();
  }

  /// Obtiene el nombre de usuario desde [UserController] usando el UID.
  Future<void> _loadUsername() async {
    final user = await UserController().getUser(widget.uid ?? '');
    if (user != null && mounted) {
      setState(() {
        username = user.username;
      });
    }
  }

  /// Obtiene la lista de géneros disponibles desde [BookController].
  Future<void> _loadGenres() async {
    final fetchedGenres = await BookController().getGenres();
    setState(() {
      genres = fetchedGenres;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.barColor,
        title: Text(username, style: Styles.customBarTextStyle),
        actions: [
          /// Botón de búsqueda que lleva a la pantalla Search.
          Searchbutton(uid: widget.uid!),
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: AppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                /// Título: libros mejor valorados
                Text(
                  loc.topRatedTitle,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                  ),
                ),
                const SizedBox(height: 10),

                /// Carrusel fijo: top 3 mejor valorados
                SizedBox(
                  height: size.height * 0.3,
                  child: BookPageview(uidUser: widget.uid),
                ),
                const SizedBox(height: 20),

                /// Carrusel fijo: libros recientes (sin filtro por género)
                CarrouselHome(
                  uid: widget.uid,
                  genre: null,
                  titleCarrousel: loc.recentTitle,
                ),
                const SizedBox(height: 10),

                /// Carruseles generados dinámicamente por cada género
                ...genres.map((genre) => CarrouselHome(
                  uid: widget.uid,
                  genre: genre,
                  titleCarrousel: genre,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

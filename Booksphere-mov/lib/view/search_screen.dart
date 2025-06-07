import 'package:booksphere/model/book_model.dart';
import 'package:booksphere/view/widgets/book_portrait.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/book_controller.dart';
import '../core/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
/// Pantalla de búsqueda de libros.
///
/// Permite buscar libros por título y filtrar por género.
/// También muestra recomendaciones si no se está buscando nada.
class Search extends StatefulWidget {
  final String? uidUser;
  final VoidCallback? onBookClosed;

  const Search({super.key, required this.uidUser, this.onBookClosed});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();

  bool haveText = false;
  bool isFilterExpanded = false;

  List<BookModel> allBooks = [];
  List<BookModel> books = [];

  List<String> genres = [];
  int selectedGenreIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController.addListener(() {
      setState(() {
        haveText = _searchController.text.isNotEmpty;
      });
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Carga la lista de libros y géneros desde el controlador.
  Future<void> _initializeData() async {
    allBooks = await BookController().getBooks();
    List<String> fetchedGenres = await BookController().getGenres();

    // Elimina "todos" y entradas vacías
    fetchedGenres = fetchedGenres
        .where((g) => g.trim().toLowerCase() != 'todos' && g.trim().isNotEmpty)
        .toList();

    setState(() {
      genres = [''] + fetchedGenres;
      books = List.from(allBooks);
    });
  }

  /// Aplica filtros de búsqueda y género a la lista de libros.
  void _applyFilters() {
    List<BookModel> filtered = allBooks;

    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((book) =>
          book.title.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    if (selectedGenreIndex != 0) {
      final selectedGenre = genres[selectedGenreIndex];
      filtered = filtered.where((book) =>
      book.genre.toLowerCase() == selectedGenre.toLowerCase()
      ).toList();
    }

    setState(() {
      books = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 12, 21),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColor.textColor, size: 25),
        ),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: kToolbarHeight * 0.7,
          child: TextField(
            controller: _searchController,
            cursorColor: AppColor.textColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(128, 0, 0, 0),
              prefixIcon: Icon(Icons.search, color: const Color.fromARGB(128, 255, 255, 255), size: 30),
              hintText: loc.searchHint,
              hintStyle: const TextStyle(color: Color.fromARGB(128, 255, 255, 255), fontSize: 16, fontFamily: 'Merriweather'),
              suffixIcon: haveText
                  ? GestureDetector(
                child: const Icon(Icons.clear_rounded, color: Color.fromARGB(128, 255, 255, 255), size: 30),
                onTap: () {
                  _searchController.clear();
                  setState(() {
                    haveText = false;
                    selectedGenreIndex = 0;
                    books = List.from(allBooks);
                  });
                },
              )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: AppColor.textColor, fontSize: 16, fontFamily: 'Merriweather'),
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // Botón para expandir o contraer el filtro de géneros
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 96, 12, 21),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.hintColor),
                  foregroundColor: AppColor.textColor,
                  backgroundColor: const Color.fromARGB(255, 96, 12, 21),
                ),
                onPressed: () {
                  setState(() {
                    isFilterExpanded = !isFilterExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.filterLabel,
                      style: const TextStyle(fontSize: 14, fontFamily: 'Merriweather'),
                    ),
                    Icon(
                      isFilterExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: AppColor.textColor,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista horizontal de géneros para filtrar
          if (isFilterExpanded)
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 96, 12, 21),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(genres.length, (index) {
                      final bool isSelected = selectedGenreIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGenreIndex = index;
                            });
                            _applyFilters();
                          },
                          child: Text(
                            genres[index].isEmpty ? "Todos" : genres[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Merriweather',
                              color: isSelected ? Colors.white : Colors.grey[400],
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

          // Título de la sección: recomendaciones o coincidencias
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                haveText && books.isEmpty
                    ? ""
                    : !haveText
                    ? loc.recommendations
                    : loc.matches,
                style: TextStyle(color: AppColor.textColor, fontSize: 18, fontFamily: 'Merriweather'),
              ),
            ),
          ),

          // Mensaje si no hay resultados
          if (haveText && books.isEmpty)
            Center(
              child: Text(
                loc.noResults,
                style: TextStyle(color: AppColor.textColor),
              ),
            ),

          // Grid de libros (imagen en formato retrato)
          Expanded(
            child: GridView.builder(
              itemCount: books.length,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.push(
                      '/book',
                      extra: {
                        'isbn': books[index].isbn,
                        'uid': widget.uidUser!,
                      },
                    ).then((_) {
                      if (widget.onBookClosed != null) {
                        widget.onBookClosed!();
                      }
                    });
                  },
                  child: BookPortrait(urlImg: books[index].urlImg),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:booksphere/model/booklists_model.dart';
import 'package:booksphere/view/widgets/carrousel_mylists.dart';
import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:flutter/material.dart';
import '../../controller/booklists_controller.dart';
import '../../core/color.dart';
import '../../model/book_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget que muestra las listas de libros del usuario, permitiendo crear nuevas listas,
/// buscar entre las existentes y filtrarlas por fecha o alfabéticamente.
class Mylisttab extends StatefulWidget {
  /// ID del usuario para cargar sus listas.
  final String? uid;

  /// Constructor de Mylisttab, requiere [uid].
  const Mylisttab({super.key, required this.uid});

  @override
  State<Mylisttab> createState() => _MylisttabState();
}

/// Estado asociado a [Mylisttab], maneja la lógica, UI y estados internos.
class _MylisttabState extends State<Mylisttab> {
  /// Indica si el modo búsqueda está activo.
  bool isSearch = false;

  /// Controla si el panel de filtro está expandido.
  bool isExpanded = false;

  /// Índice de la categoría de filtro seleccionada (0 = fecha, 1 = A-Z).
  int selectedCategory = 0;

  /// Listado de listas de libros actualmente visibles.
  List<BookLists> bookLists = [];

  /// Copia de las listas para restaurar tras búsqueda.
  List<BookLists> filteredBookLists = [];

  /// Controlador del campo de texto de búsqueda.
  TextEditingController _searchController = TextEditingController();

  /// Controlador del campo de texto para el nombre de nueva lista.
  TextEditingController _nameController = TextEditingController();

  /// Indica si hay texto en el campo de búsqueda para mostrar iconos condicionales.
  bool haveText = false;

  /// Mapeo entre el nombre de la lista y los libros que contiene.
  Map<String, List<BookModel>> booksByList = {};

  /// Opciones de filtro disponibles.
  final List<String> filter = ['Fecha de creación', 'A-Z'];

  @override
  void initState() {
    super.initState();
    // Carga inicial de datos al iniciar el widget.
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
    // Limpia las listas y mapas para liberar recursos.
    bookLists = [];
    booksByList = {};
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar:
      !isSearch
          ? AppBar(
        backgroundColor: Color.fromARGB(255, 96, 12, 21),
        centerTitle: true,
        title: Text(
          loc.myLists,
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 18,
            fontFamily: 'Merriweather',
          ),
        ),
        actions: [
          // Botón para mostrar modal y crear nueva lista
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    height: size.height * 0.8,
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                        right: 40,
                        left: 40,
                      ),
                      child: Column(
                        children: [
                          Text(
                            loc.createListPrompt,
                            style: TextStyle(
                              color: AppColor.textGoogleColor,
                              fontSize: 24,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Campo para ingresar el nombre de la nueva lista
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: loc.listNameHint,
                              hintStyle: TextStyle(
                                color: AppColor.textGoogleColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: SmartButton(
                              title:loc.create,
                              onPressed: () async {
                                // Crear lista solo si el campo no está vacío
                                if (_nameController.text.trim().isNotEmpty) {
                                  await BookListsController()
                                      .createBookList(
                                    widget.uid ?? '',
                                    _nameController.text.trim(),
                                    '',
                                  );
                                  // Recarga listas tras creación
                                  await _loadBookListsAndBooks();
                                  _nameController.clear();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.add, color: AppColor.textColor, size: 30),
          ),
          // Botón para activar/desactivar búsqueda
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });
            },
            icon: Icon(
              Icons.search,
              color: AppColor.textColor,
              size: 30,
            ),
          ),
        ],
      )
          : AppBar(
        backgroundColor: Color.fromARGB(255, 96, 12, 21),
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: kToolbarHeight * 0.7,
          // Campo de búsqueda
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                haveText = _searchController.text.isNotEmpty;
              });
              _loadBookListsAndBooks();
            },
            cursorColor: AppColor.textColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(128, 0, 0, 0),
              prefixIcon: Icon(
                Icons.search,
                color: Color.fromARGB(128, 255, 255, 255),
                size: 30,
              ),
              hintText: loc.searchListsHint,
              hintStyle: TextStyle(
                color: Color.fromARGB(128, 255, 255, 255),
                fontSize: 16,
                fontFamily: 'Merriweather',
              ),
              suffixIcon:
              haveText
                  ? GestureDetector(
                child: Icon(
                  Icons.clear_rounded,
                  color: Color.fromARGB(128, 255, 255, 255),
                  size: 30,
                ),
                onTap: () {
                  setState(() {
                    _searchController.clear();
                    haveText = false;
                    _initializeData();
                  });
                },
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 16,
              fontFamily: 'Merriweather',
            ),
          ),
        ),
        actions: [
          // Botón para salir del modo búsqueda
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                haveText = false;
                bookLists = List.from(filteredBookLists);
                // Ordenar según filtro activo
                if (selectedCategory == 0) {
                  bookLists.sort(
                        (a, b) => DateTime.parse(
                      b.dateCreation,
                    ).compareTo(DateTime.parse(a.dateCreation)),
                  );
                } else {
                  bookLists.sort(
                        (a, b) => a.name.toLowerCase().compareTo(b.name),
                  );
                }
                isSearch = !isSearch;
              });
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColor.textColor,
              size: 25,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Color.fromARGB(255, 96, 12, 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // Botón para mostrar/ocultar filtro
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              loc.filter,
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 14,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: AppColor.textColor,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Panel de filtro expandible
              if (isExpanded)
                Container(
                  width: double.infinity,
                  color: Color.fromARGB(128, 0, 0, 0),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      child: Center(
                        child: Row(
                          children: List.generate(filter.length, (index) {
                            final bool isSelected = selectedCategory == index;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = index;

                                    // Ordenar listas según filtro seleccionado
                                    if (selectedCategory == 0) {
                                      bookLists.sort(
                                            (a, b) => DateTime.parse(
                                          b.dateCreation,
                                        ).compareTo(
                                          DateTime.parse(a.dateCreation),
                                        ),
                                      );
                                    } else {
                                      bookLists.sort(
                                            (a, b) => a.name
                                            .toLowerCase()
                                            .compareTo(b.name),
                                      );
                                    }
                                  });
                                },
                                child: Text(
                                  filter[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Merriweather',
                                    color:
                                    isSelected ? Colors.white : Colors.grey,
                                    fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              // Mensaje si no hay listas y estamos en modo búsqueda
              ...(bookLists.isEmpty && isSearch)
                  ? <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    loc.noListsFound,
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 16,
                      fontFamily: 'Merriweather',
                    ),
                  ),
                ),
              ]
              // Lista de carruseles con las listas y sus libros
                  : List.generate(
                bookLists.length,
                    (index) => CarrouselMylists(
                  bookLists: bookLists[index],
                  uid: widget.uid,
                  books: booksByList[bookLists[index].name] ?? [],
                  onBookDeleted: () async {
                    // Refrescar listas cuando un libro es eliminado
                    await _loadBookListsAndBooks();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Inicializa la carga de listas y libros.
  Future<void> _initializeData() async {
    await _loadBookListsAndBooks();
  }

  /// Carga las listas de libros y los libros dentro de cada lista.
  ///
  /// - Obtiene todas las listas para el usuario.
  /// - Obtiene los libros de cada lista.
  /// - Aplica filtros y ordenamiento.
  /// - Actualiza el estado para refrescar la UI.
  Future<void> _loadBookListsAndBooks() async {
    final lists = await BookListsController().getBookLists(widget.uid ?? '');
    Map<String, List<BookModel>> tempBooks = {};

    // Obtener libros para cada lista
    for (var list in lists) {
      tempBooks[list.name] = await BookListsController().getBooksFromList(
        widget.uid ?? '',
        list.name,
      );
    }

    // Copia para filtrar y ordenar
    List<BookLists> tempFiltered = List.from(lists);

    // Ordenar según categoría seleccionada
    if (selectedCategory == 0) {
      tempFiltered.sort(
            (a, b) => DateTime.parse(
          b.dateCreation,
        ).compareTo(DateTime.parse(a.dateCreation)),
      );
    } else {
      tempFiltered.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    // Filtrar por texto de búsqueda si existe
    final searchText = _searchController.text.toLowerCase();
    if (searchText.isNotEmpty) {
      tempFiltered =
          tempFiltered
              .where((list) => list.name.toLowerCase().contains(searchText))
              .toList();
    }

    // Actualizar estado si el widget sigue montado
    if (mounted) {
      setState(() {
        bookLists = tempFiltered;
        filteredBookLists = List.from(lists);
        booksByList = tempBooks;
      });
    }
  }
}

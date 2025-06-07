import 'package:booksphere/view/widgets/row_book.dart';
import 'package:booksphere/view/widgets/row_new_book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controller/booklists_controller.dart';
import '../controller/user_controller.dart';
import '../core/color.dart';
import '../model/book_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla que representa una lista personalizada de libros creada por un usuario.
/// Permite ver, editar, eliminar y añadir libros a una lista existente.
class Booklist extends StatefulWidget {
  /// UID del usuario dueño de la lista.
  final String uid;

  /// Nombre de la lista.
  final String name;

  const Booklist({super.key, required this.uid, required this.name});

  @override
  State<Booklist> createState() => _BooklistState();
}

class _BooklistState extends State<Booklist> {
  String nameUser = '';
  List<BookModel> books = [];
  List<BookModel> allBooks = [];
  bool isEdit = false;
  late TextEditingController _nameController;
  String oldName = '';
  late TextEditingController _bookController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _bookController = TextEditingController();
    oldName = widget.name;
    _initializeData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return WillPopScope(
      // Previene el retroceso por defecto y envía una señal al cerrar la pantalla
      onWillPop: () {
        context.pop('delete');
        return Future.value(false);
      },
      child: Scaffold(
        // AppBar en modo normal o edición
        appBar: !isEdit
            ? AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop('delete');
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.textColor,
              size: 25,
            ),
          ),
          title: Text(
            oldName,
            style: TextStyle(
              color: AppColor.textColor,
              fontSize: 20,
              fontFamily: 'Merriweather',
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 96, 12, 21),
          actions: [
            // Botón para activar el modo de edición
            TextButton(
              onPressed: () {
                setState(() {
                  isEdit = true;
                });
              },
              child: Text(
                loc.edit,
                style: TextStyle(color: AppColor.textColor),
              ),
            ),
            // Botón para eliminar la lista
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(loc.delete),
                      content: Text(
                        AppLocalizations.of(context)!.deleteListConfirmation,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await _deleteList();
                            Navigator.of(context).pop();
                            context.pop('delete');
                          },
                          child: Text(loc.yes),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(loc.no),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                loc.delete,
                style: TextStyle(color: AppColor.textColor),
              ),
            ),
          ],
        )
            : AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 96, 12, 21),
          centerTitle: true,
          title: Text(
            loc.editList,
            style: TextStyle(color: AppColor.textColor, fontSize: 20),
          ),
          actions: [
            // Botón para confirmar edición del nombre de la lista
            TextButton(
              onPressed: () async {
                String newName = _nameController.text.trim();
                if (newName.isNotEmpty && newName != oldName) {
                  await BookListsController().updateListName(
                    widget.uid,
                    oldName,
                    newName,
                  );
                  oldName = newName;
                }
                setState(() {
                  isEdit = false;
                });
              },
              child: Text(
                loc.done ,
                style: TextStyle(color: AppColor.textColor),
              ),
            ),
          ],
        ),
        body: Container(
          color: AppColor.backgroundColor,
          height: size.height,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mostrar nombre del usuario o campo editable del nombre de la lista
                !isEdit
                    ? Text(
                  nameUser,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                  ),
                )
                    : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      autofocus: true,
                      cursorColor: AppColor.textColor,
                      textAlign: TextAlign.center,
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: loc.editNameList,
                        hintStyle: TextStyle(
                          color: AppColor.hintColor,
                          fontSize: 20,
                        ),
                      ),
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                // Lista de libros en la lista personalizada
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: books.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RowBook(
                              edit: isEdit,
                              nameList: oldName,
                              uidUser: widget.uid,
                              bookModel: books[index],
                              onListDeleted: () async {
                                await _loadBooksFromList();
                              },
                            ),
                          );
                        },
                      ),
                      // Botón para añadir libros a la lista (solo si no está en modo edición)
                      !isEdit
                          ? Positioned(
                        bottom: 20,
                        right: 0,
                        child: FloatingActionButton(
                          shape: CircleBorder(),
                          backgroundColor:
                          const Color.fromARGB(255, 96, 12, 21),
                          elevation: 5,
                          onPressed: () {
                            // Mostrar modal inferior para buscar y agregar libro
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                      Colors.white.withOpacity(0.9),
                                      borderRadius:
                                      const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 40,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          loc.addToListName(oldName),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontFamily: 'Merriweather',
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        TextField(
                                          cursorColor:
                                          AppColor.textGoogleColor,
                                          textAlign: TextAlign.center,
                                          controller: _bookController,
                                          onChanged: (value) {
                                            _bookController.text = value;
                                          },
                                          decoration:
                                          InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                            AppLocalizations.of(context)!.searchByTitleHint,
                                            hintStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: 'Merriweather',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: size.height * 0.6,
                                          child: RowNewBook(
                                            uidUser: widget.uid,
                                            nameList: oldName,
                                            controller: _bookController,
                                            onListDeleted: () async {
                                              await _loadBooksFromList();
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
                          child: Icon(
                            Icons.add,
                            color: AppColor.textColor,
                            size: 25,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Inicializa los datos: nombre del usuario y libros de la lista.
  Future<void> _initializeData() async {
    await _getNameUser();
    await _loadBooksFromList();
  }

  /// Obtiene el nombre del usuario dueño de la lista.
  Future<void> _getNameUser() async {
    final user = await UserController().getUser(widget.uid);
    if (user != null && mounted) {
      setState(() {
        nameUser = user.username;
      });
    }
  }

  /// Carga los libros asociados a la lista.
  Future<void> _loadBooksFromList() async {
    final books = await BookListsController().getBooksFromList(
      widget.uid,
      oldName,
    );
    if (mounted) {
      setState(() {
        this.books = books;
        allBooks = books;
      });
    }
  }

  /// Elimina la lista del usuario.
  Future<void> _deleteList() async {
    await BookListsController().deleteList(widget.uid, oldName);
  }
}

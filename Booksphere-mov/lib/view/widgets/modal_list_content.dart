import 'package:booksphere/view/widgets/smartbutton.dart';
import 'package:flutter/material.dart';

import '../../controller/booklists_controller.dart';
import '../../core/styles.dart';
import '../../model/booklists_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
/// Widget que muestra el contenido del modal para crear listas y añadir/eliminar un libro de ellas.
/// Recibe el [uidUser] del usuario y el [isbn] del libro a gestionar.
class ModalContent extends StatefulWidget {
  final String uidUser;
  final String isbn;

  const ModalContent({super.key, required this.uidUser, required this.isbn});

  @override
  State<ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
  final TextEditingController nameController = TextEditingController();
  List<BookLists> bookLists = [];

  @override
  void initState() {
    super.initState();
    _loadBookLists();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: size.height * 0.8,
      child: Column(
        children: [
          // Botón para crear una nueva lista
          Padding(
            padding: const EdgeInsets.only(top: 60.0, right: 40, left: 40),
            child: SizedBox(
              width: double.infinity,
              child: SmartButton(
                title: loc.createList ,
                onPressed: () {
                  // Mostrar diálogo para introducir nombre de la lista
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(child: Text(AppLocalizations.of(context)!.enterName)),
                      content: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.listNameHint,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: SmartButton(
                                title: AppLocalizations.of(context)!.create,
                                onPressed: () async {
                                  if (nameController.text.trim().isNotEmpty) {
                                    await _createBookList();
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Título sección listas del usuario
          Text(loc.yourLists, style: Styles.googleButtonTextStyle),

          const SizedBox(height: 10),

          // Listado de listas con opción de añadir o quitar el libro actual
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: bookLists.isEmpty
                  ? Center(child: Text(AppLocalizations.of(context)!.noLists))
                  : ListView.builder(
                itemCount: bookLists.length,
                itemBuilder: (context, index) {
                  final list = bookLists[index];
                  final isInList = list.idBook.contains(widget.isbn);

                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Merriweather',
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (isInList) {
                              await BookListsController().removeBookFromList(
                                widget.uidUser,
                                list.name,
                                widget.isbn,
                              );
                            } else {
                              await BookListsController().addBookToList(
                                widget.uidUser,
                                list.name,
                                widget.isbn,
                              );
                            }
                            await _loadBookLists();
                          },
                          icon: Icon(
                            isInList ? Icons.check : Icons.add,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Carga las listas de libros del usuario desde el controlador
  Future<void> _loadBookLists() async {
    final loadedBookLists = await BookListsController().getBookLists(widget.uidUser);
    if (mounted) {
      setState(() {
        bookLists = loadedBookLists;
      });
    }
  }

  /// Crea una nueva lista de libros con el nombre indicado y añade el libro actual
  Future<void> _createBookList() async {
    await BookListsController().createBookList(
      widget.uidUser,
      nameController.text.trim(),
      widget.isbn,
    );
    nameController.clear();
    await _loadBookLists();
  }
}

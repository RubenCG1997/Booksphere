import 'package:flutter/material.dart';
import '../../core/styles.dart';
import 'modal_list_content.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget que muestra un icono para abrir un modal donde se puede añadir un libro a una lista.
/// Recibe el [uidUser] y el [isbn] del libro que se quiere añadir.
class ModalList extends StatefulWidget {
  final String? uidUser;
  final String? isbn;

  const ModalList({super.key, required this.uidUser, required this.isbn});

  @override
  State<ModalList> createState() => _ModalListState();
}

class _ModalListState extends State<ModalList> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        /// Botón con icono que abre un modal bottom sheet para añadir a lista.
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => ModalContent(
                uidUser: widget.uidUser!,
                isbn: widget.isbn!,
              ),
            );
          },
          icon: const Icon(Icons.add_box, color: Colors.white, size: 50),
        ),

        /// Texto que indica la acción del botón.
        Text(loc.addToList, style: Styles.customTextFieldStyle),
      ],
    );
  }
}

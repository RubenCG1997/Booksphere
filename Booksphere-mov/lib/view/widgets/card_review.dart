import 'package:booksphere/model/review_model.dart';
import 'package:flutter/material.dart';

import '../../controller/review_controller.dart';
import '../../controller/user_controller.dart';
import '../../core/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
/// Widget que representa una tarjeta para mostrar una reseña de un libro.
///
/// Muestra el nombre del usuario que hizo la reseña, la valoración con estrellas,
/// la fecha y el comentario. Si el usuario actual es el autor de la reseña,
/// permite eliminarla mediante un diálogo de confirmación.
///
/// También permite actualizar la lista de reseñas mediante el callback [onReviewSubmitted].
class CardReview extends StatefulWidget {
  /// La reseña a mostrar.
  final ReviewModel review;

  /// ID del usuario actual (para verificar si puede eliminar su reseña).
  final String? uidUser;

  /// Callback que se llama cuando se envía o elimina una reseña para actualizar el estado padre.
  final VoidCallback? onReviewSubmitted;

  /// Indica si existe reseña previa (puede ser usado para condicionales en el padre).
  final bool? hasReview;

  /// Controlador de texto para el campo de reseña.
  final TextEditingController controller;

  const CardReview({
    super.key,
    required this.review,
    required this.uidUser,
    required this.onReviewSubmitted,
    required this.hasReview,
    required this.controller,
  });

  @override
  State<CardReview> createState() => _CardReviewState();
}

class _CardReviewState extends State<CardReview> {
  String? username;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila con el nombre del usuario y el botón de eliminar si corresponde.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  username ?? loc.loadingUsername,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Merriweather',
                  ),
                ),
                // Solo muestra el botón eliminar si el usuario actual es el autor.
                widget.uidUser == widget.review.idUser
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Mostrar diálogo para confirmar eliminación.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(loc.deleteReviewTitle),
                              content: Text(
                                loc.deleteReviewConfirmation,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    // Eliminar la reseña.
                                    await ReviewController().deleteReview(
                                      widget.review.idReview,
                                    );
                                    widget.controller.clear();
                                    widget.onReviewSubmitted?.call();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(loc.yes),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(loc.cancel),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 8),

            // Fila con la valoración en estrellas y la fecha de la reseña.
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color: index < widget.review.stars ? Colors.yellow : Colors.grey,
                    size: 16,
                  );
                }),
                SizedBox(width: 8),
                Text(
                  widget.review.date,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 14,
                    fontFamily: 'Merriweather',
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Comentario de la reseña.
            Text(
              widget.review.comentary,
              style: TextStyle(
                color: AppColor.textColor,
                fontSize: 14,
                fontFamily: 'Merriweather',
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
    username = '';
  }

  /// Inicializa datos adicionales, como obtener el nombre del usuario que hizo la reseña.
  Future<void> _initializeData() async {
    final fetchedUser = await UserController().getUser(widget.review.idUser);

    if (!mounted) return;

    setState(() {
      username = fetchedUser?.username ?? 'Usuario';
    });

    // Llama el callback para actualizar la UI del padre si es necesario.
    widget.onReviewSubmitted?.call();
  }
}

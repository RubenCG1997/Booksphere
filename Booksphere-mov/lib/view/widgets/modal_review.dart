import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';

import '../../controller/review_controller.dart';
import '../../core/color.dart';
import '../../model/review_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModalReview extends StatefulWidget {
  // Parámetros necesarios para identificar usuario, libro, estado de reseña,
  // callback para actualizar la UI externa y el controlador del TextField
  final String? uidUser, isbn;
  final bool? hasReview;
  final VoidCallback? onReviewSubmitted;
  final TextEditingController controller;

  const ModalReview({
    super.key,
    required this.uidUser,
    required this.isbn,
    required this.hasReview,
    required this.onReviewSubmitted,
    required this.controller,
  });

  @override
  State<ModalReview> createState() => _ModalReviewState();
}

class _ModalReviewState extends State<ModalReview> {
  // Rating actual, inicializado en 1 estrella
  int rating = 1;

  // Modelo que almacena la reseña actual
  ReviewModel review = ReviewModel.empty();

  @override
  void initState() {
    super.initState();
    // Cargar reseña guardada (si existe) al iniciar el widget
    _loadReview();
  }

  @override
  void dispose() {
    // Limpiar el texto cuando se destruya el widget
    widget.controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Botón de ícono para abrir el modal de reseña
        IconButton(
          icon: Icon(Icons.rate_review, color: Colors.white, size: 50),
          onPressed: () {
            // Mostrar modal inferior para escribir o editar la reseña
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true, // Permite ocupar más espacio vertical
              context: context,
              builder:
                  (context) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // Fondo translúcido
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    height:
                        size.height * 0.8, // Altura del modal: 80% de pantalla
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Título del modal
                        Text(
                          AppLocalizations.of(context)!.reviewTitle,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Merriweather',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Campo de texto para escribir la reseña
                        TextField(
                          controller: widget.controller,
                          maxLength: 100,
                          maxLines: 5,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            // Si no hay reseña previa, mostrar hint
                            hintText:
                                widget.hasReview! ? '' : AppLocalizations.of(context)!.writeReviewHint,
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Merriweather',
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Barra para seleccionar calificación en estrellas
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar(
                              onRatingChanged: (value) {
                                setState(() {
                                  rating =
                                      value
                                          .toInt(); // Actualiza el rating local
                                });
                              },
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                              initialRating: rating.toDouble(),
                              maxRating: 5,
                              filledColor: Colors.yellow,
                              emptyColor: Colors.grey,
                              size: 40,
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Botón para enviar la reseña
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final text = widget.controller.text.trim();
                              if (text.isEmpty)
                                return; // No permitir reseñas vacías

                              if (widget.hasReview!) {
                                // Editar reseña existente
                                await ReviewController().editReview(
                                  review.idReview,
                                  text,
                                  rating,
                                );
                              } else {
                                // Crear nueva reseña
                                await ReviewController().addReview(
                                  widget.uidUser!,
                                  widget.isbn!,
                                  text,
                                  rating,
                                );
                              }

                              // Llamar callback externo (si existe) para actualizar UI
                              widget.onReviewSubmitted?.call();

                              // Recargar reseña después de enviar
                              await _loadReview();

                              // Cerrar modal si el widget sigue montado
                              if (mounted) Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                208,
                                135,
                                145,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              loc.sendReview,
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 20,
                                fontFamily: 'Merriweather',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
            );
          },
        ),
        // Texto debajo del ícono que indica si se va a editar o escribir
        Text(
          widget.hasReview! ?  AppLocalizations.of(context)!.editReview :  AppLocalizations.of(context)!.writeReviewHint,
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: 14,
            fontFamily: 'Merriweather',
          ),
        ),
      ],
    );
  }

  /// Metodo para cargar la reseña actual desde el controlador.
  /// Se actualiza el estado local y el TextField con el contenido recuperado.
  Future<void> _loadReview() async {
    // Obtener la reseña correspondiente al usuario y libro
    final fetchedReview = await ReviewController().getReviewbyUserAndBook(
      widget.uidUser!,
      widget.isbn!,
    );
    // Si el widget aún está montado, actualizar el estado
    if (mounted) {
      setState(() {
        review = fetchedReview;
        widget.controller.text = review.comentary;
        // Si no hay estrellas asignadas, se usa al menos una por defecto
        rating = (review.stars == 0) ? 1 : review.stars;
      });
    }
  }
}

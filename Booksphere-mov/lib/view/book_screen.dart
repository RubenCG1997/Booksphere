import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/author_controller.dart';
import '../controller/book_controller.dart';
import '../controller/publisher_controller.dart';
import '../controller/review_controller.dart';
import '../core/color.dart';
import '../core/styles.dart';
import '../model/book_model.dart';
import '../model/review_model.dart';
import '../view/widgets/book_portrait.dart';
import '../view/widgets/card_review.dart';
import '../view/widgets/elevated_pop.dart';
import '../view/widgets/modal_list.dart';
import '../view/widgets/modal_review.dart';
import '../view/widgets/smartbutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla que muestra los detalles completos de un libro,
/// incluyendo información del autor, editorial, descripción, reseñas
/// y acciones como leer el libro o dejar una reseña.
class Book extends StatefulWidget {
  /// UID del usuario actual.
  final String? uidUser;

  /// ISBN del libro a mostrar.
  final String? isbn;

  const Book({super.key, required this.isbn, required this.uidUser});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  String nameAuthor = '';
  String namePublisher = '';
  BookModel bookModel = BookModel.empty();
  List<ReviewModel> reviews = [];
  bool hasReview = false;
  double averageRating = 0.0;
  String commentary = '';
  ReviewModel review = ReviewModel.empty();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loc = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async {
        context.pop('delete');
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    child: BookPortrait(urlImg: bookModel.urlImg),
                  ),
                  const Positioned(top: 20, right: 0, child: ElevatedPop()),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(bookModel.title, style: Styles.customTextFieldStyle),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bookModel.date, style: Styles.customTextFieldStyle),
                  Text(
                    reviews.isNotEmpty ? '${averageRating.toStringAsFixed(1)}/5' : loc.noReviews,
                    style: Styles.customTextFieldStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SmartButton(
                title: loc.readBook,
                onPressed: () {
                  context.push(
                    '/reader',
                    extra: {
                      'urlEpub': bookModel.urlEpub,
                      'uidUser': widget.uidUser,
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
              Text(
                bookModel.description,
                style: Styles.customTextFieldStyle,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(loc.author(nameAuthor), style: Styles.customHintTextStyle),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(loc.publisher(namePublisher), style: Styles.customHintTextStyle),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ModalList(uidUser: widget.uidUser, isbn: widget.isbn),
                  const SizedBox(width: 40),
                  ModalReview(
                    uidUser: widget.uidUser,
                    isbn: widget.isbn,
                    onReviewSubmitted: () {
                      _loadReviews();
                      _loadReview();
                      _hasReview();
                      _calculateAverageRating();
                    },
                    controller: controller,
                    hasReview: hasReview,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(loc.reviews,
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontSize: 20,
                    fontFamily: 'Merriweather',
                  )),
              const SizedBox(height: 10),
              reviews.isEmpty
                  ? Center(
                child: Text(
                 loc.noReviews,
                  style: Styles.customHintTextStyle,
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return CardReview(
                    key: Key(reviews[index].idReview),
                    review: reviews[index],
                    onReviewSubmitted: () {
                      _hasReview();
                      _calculateAverageRating();
                      _loadReviews();
                      _loadReview();
                    },
                    uidUser: widget.uidUser,
                    hasReview: hasReview,
                    controller: controller,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Inicializa todos los datos necesarios al cargar la pantalla.
  Future<void> _initializeData() async {
    await _loadBook();
    await _loadAuthor();
    await _loadPublisher();
    await _loadReview();
    await _loadReviews();
    await _hasReview();
    await _calculateAverageRating();
  }

  /// Obtiene los datos del libro desde el controlador.
  Future<void> _loadBook() async {
    bookModel = (await BookController().getBook(widget.isbn.toString()))!;
    if (mounted) setState(() {});
  }

  /// Obtiene el nombre del autor.
  Future<void> _loadAuthor() async {
    nameAuthor = (await AuthorController().getNameAuthor(bookModel.idAuthor))!;
    if (mounted) setState(() {});
  }

  /// Obtiene el nombre de la editorial.
  Future<void> _loadPublisher() async {
    namePublisher =
    (await PublisherController().getNamePublisher(bookModel.idPublisher))!;
    if (mounted) setState(() {});
  }

  /// Obtiene todas las reseñas del libro.
  Future<void> _loadReviews() async {
    reviews = await ReviewController().getReviews(widget.isbn.toString());
    if (mounted) setState(() {});
  }

  /// Verifica si el usuario ya hizo una reseña.
  Future<void> _hasReview() async {
    hasReview = await ReviewController().hasReview(
      widget.uidUser!,
      widget.isbn!,
    );
    if (mounted) setState(() {});
  }

  /// Obtiene la reseña individual del usuario.
  Future<void> _loadReview() async {
    review = await ReviewController().getReview(review.idReview);
    if (mounted) setState(() {});
  }

  /// Calcula la calificación promedio del libro.
  Future<void> _calculateAverageRating() async {
    averageRating = await ReviewController()
        .calculateAverageRating(widget.isbn.toString());
    if (mounted) setState(() {});
  }
}

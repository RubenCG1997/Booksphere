import 'package:booksphere/model/user_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/review_controller.dart';
import '../../controller/user_controller.dart';
import '../../core/color.dart';
import '../../model/book_model.dart';
import '../../model/review_model.dart';
import '../widgets/book_portrait.dart';
import '../widgets/card_review.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Widget que representa la pestaña de perfil de usuario.
/// Muestra información del usuario, sus seguidores, seguidos, libros leídos y reseñas.
class Profiletab extends StatefulWidget {
  /// ID del usuario cuyo perfil se está mostrando
  final String? uid;

  /// Constructor del widget Profiletab
  const Profiletab({super.key, required this.uid});

  @override
  State<Profiletab> createState() => _ProfiletabState();
}

class _ProfiletabState extends State<Profiletab>
    with SingleTickerProviderStateMixin {
  /// Lista de IDs de seguidores del usuario
  List<String> followers = [];

  /// Modelo del usuario actual
  UserModel? user;

  /// Lista de IDs de usuarios que sigue el usuario actual
  List<String> follows = [];

  /// Lista de usuarios encontrados en la búsqueda
  List<UserModel> searchUsers = [];

  /// Lista de todos los usuarios (excepto el actual)
  List<UserModel> allUsers = [];

  /// Lista de libros leídos por el usuario
  List<BookModel> readerBooks = [];

  /// Lista de reseñas hechas por el usuario
  List<ReviewModel> reviews = [];

  /// Nombre de usuario actual
  String username = '';

  /// Controlador para las pestañas del perfil
  late TabController _tabController;

  /// Controlador para el campo de búsqueda
  final TextEditingController _searchController = TextEditingController();

  /// Indica si hay texto en el campo de búsqueda
  bool haveText = false;

  /// Indica si el campo de búsqueda está enfocado
  bool isFocused = false;

  /// Usuario actual autenticado en Firebase
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _getUsername();
    _getFollowers();
    _getFollows();
    _getReaderBooks();
    _getReviews();
    _loadAllUsers();
    _getUser();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    username = '';
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.list,
                  size: 35,
                  color: Colors.white,
                ),
                items: [
                  ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
                  ),
                  const DropdownMenuItem<Divider>(
                    enabled: false,
                    child: Divider(),
                  ),
                  ...MenuItems.secondItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
                  ),
                ],
                onChanged: (value) {
                  MenuItems.onChanged(context, value! as MenuItem, user ?? UserModel.empty());
                },
                dropdownStyleData: DropdownStyleData(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  offset: const Offset(0, 8),
                ),
                menuItemStyleData: MenuItemStyleData(
                  customHeights: [
                    ...List<double>.filled(MenuItems.firstItems.length, 48),
                    8,
                    ...List<double>.filled(MenuItems.secondItems.length, 48),
                  ],
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 96, 12, 21),
        centerTitle: true,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: kToolbarHeight * 0.7,
          child: TextField(
            onTap: () {
              setState(() {
                isFocused = true;
                searchUsers = allUsers;
              });
            },
            onSubmitted: (value) {
              setState(() {
                isFocused = false;
                _searchController.clear();
              });
            },
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                haveText = _searchController.text.isNotEmpty;
                if (_searchController.text.isEmpty && !haveText) {
                  searchUsers = allUsers;
                } else {
                  searchUsers =
                      allUsers
                          .where(
                            (user) => user.username.toLowerCase().contains(
                          value.toLowerCase(),
                        ),
                      )
                          .toList();
                }
              });
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
              hintText: 'Busca un usuario...',
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
                  });
                },
              )
                  : null,
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      ),
      body:
      !isFocused
          ? Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Text(
                username,
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: 20,
                  fontFamily: 'Merriweather',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await context.push(
                          '/listfolloweruser',
                          extra: {'uid': widget.uid},
                        );
                        _refreshFollowData();
                      },
                      child: Column(
                        children: [
                          Text(
                            '${followers.length}',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Seguidores',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context.push(
                          '/listfollowuser',
                          extra: {'uid': widget.uid},
                        );
                        _refreshFollowData();
                      },
                      child: Column(
                        children: [
                          Text(
                            '${follows.length}',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Seguidos',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  labelColor: AppColor.textColor,
                  tabs: [
                    Tab(icon: Icon(Icons.bookmark, size: 30)),
                    Tab(icon: Icon(Icons.reviews, size: 30)),
                    Tab(icon: Icon(Icons.stars, size: 30)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    readerBooks.isNotEmpty
                        ? Center(
                      child: GridView.builder(
                        itemCount: readerBooks.length,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await context.push(
                                '/book',
                                extra: {
                                  'isbn': readerBooks[index].isbn,
                                  'uid': widget.uid!,
                                },
                              );
                              _getReviews();
                            },
                            child: BookPortrait(
                              urlImg: readerBooks[index].urlImg,
                            ),
                          );
                        },
                      ),
                    )
                        : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/open_book.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            'No estas o has leido ningún libro todavia',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ],
                      ),
                    ),
                    reviews.isNotEmpty
                        ? ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return CardReview(
                          review: review,
                          uidUser: widget.uid,
                          onReviewSubmitted: () {
                            _getReviews();
                          },
                          hasReview: true,
                          controller: TextEditingController(),
                        );
                      },
                    )
                        : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.reviews,
                            color: AppColor.textColor,
                            size: 150,
                          ),
                          Text(
                            'Realiza una reseña de un libro',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 16,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (searchUsers.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: searchUsers.length,
                    itemBuilder: (context, index) {
                      final user = searchUsers[index];
                      bool isFollowing = follows.contains(user.uid);
                      bool isCurrentUser = user.uid == currentUser?.uid;
                      return ListTile(
                        title: Text(
                          user.username,
                          style: TextStyle(color: AppColor.textColor),
                        ),
                        subtitle: Text(
                          user.email,
                          style: TextStyle(color: AppColor.hintColor),
                        ),
                        trailing:
                        isCurrentUser
                            ? null
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            backgroundColor:
                            isFollowing
                                ? Colors.redAccent
                                : AppColor.smartButtonColor,
                          ),
                          onPressed: () async {
                            if (isFollowing) {
                              // Dejar de seguir
                              await UserController()
                                  .unfollowUser(
                                currentUser!.uid,
                                user.uid,
                              );
                            } else {
                              // Seguir
                              await UserController().followUser(
                                currentUser!.uid,
                                user.uid,
                              );
                            }
                            await _refreshFollowData();
                          },
                          child: Text(
                            isFollowing
                                ? 'Dejar de seguir'
                                : 'Seguir',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ),
                        onTap: () {
                          context.push(
                            '/profile',
                            extra: {'uid': user.uid},
                          );
                        },
                      );
                    },
                  ),
                )
              else
                Center(
                  child: Text(
                    'No se encontraron usuarios',
                    style: TextStyle(color: AppColor.textColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Obtiene los datos del usuario actual
  Future<void> _getUser() async {
    UserModel? user = await UserController().getUser(widget.uid ?? '');
    if (mounted) {
      setState(() {
        this.user = user;
      });
    }
  }

  /// Obtiene el nombre de usuario actual
  Future<void> _getUsername() async {
    UserModel? nameUser = await UserController().getUser(widget.uid ?? '');
    if (mounted) {
      setState(() {
        username = nameUser?.username ?? 'Usuario';
      });
    }
  }

  /// Obtiene la lista de seguidores del usuario
  Future<void> _getFollowers() async {
    List<String> listFollowers = await UserController().getFollowersIdUsers(
      widget.uid ?? '',
    );
    if (mounted) {
      setState(() {
        followers = listFollowers;
      });
    }
  }

  /// Obtiene la lista de usuarios que sigue el usuario actual
  Future<void> _getFollows() async {
    List<String> listFollows = await UserController().getFollowsIdUsers(
      widget.uid ?? '',
    );
    if (mounted) {
      setState(() {
        follows = listFollows;
      });
    }
  }

  /// Obtiene la lista de libros leídos por el usuario
  Future<void> _getReaderBooks() async {
    List<BookModel> listReaderBooks = await UserController().getReaderBooks(
      widget.uid ?? '',
    );
    if (mounted) {
      setState(() {
        readerBooks = listReaderBooks;
      });
    }
  }

  /// Obtiene las reseñas hechas por el usuario
  Future<void> _getReviews() async {
    List<ReviewModel> listReviews = await ReviewController().getReviewsByUser(
      widget.uid ?? '',
    );
    if (mounted) {
      setState(() {
        reviews = listReviews;
      });
    }
  }

  /// Actualiza los datos de seguidores y seguidos
  Future<void> _refreshFollowData() async {
    final newFollowers = await UserController().getFollowersIdUsers(
      widget.uid ?? '',
    );
    final newFollows = await UserController().getFollowsIdUsers(
      widget.uid ?? '',
    );

    if (mounted) {
      setState(() {
        followers = newFollowers;
        follows = newFollows;
      });
    }
  }

  /// Carga todos los usuarios (excepto el actual)
  Future<void> _loadAllUsers() async {
    List<UserModel> listUsers = await UserController().getAllUsers(widget.uid!);
    if (mounted) {
      setState(() {
        allUsers = listUsers;
      });
    }
  }
}

/// Clase abstracta que define los ítems del menú desplegable
abstract class MenuItems {
  /// Primer grupo de ítems del menú
  static const List<MenuItem> firstItems = [home, share];

  /// Segundo grupo de ítems del menú
  static const List<MenuItem> secondItems = [logout];

  /// Ítem para ir al perfil
  static const home = MenuItem(text: 'Perfil', icon: Icons.person);

  /// Ítem para gestionar suscripción
  static const share = MenuItem(text: 'Suscripcion', icon: Icons.monetization_on);

  /// Ítem para cerrar sesión
  static const logout = MenuItem(text: 'Salir', icon: Icons.logout);

  /// Construye un widget para un ítem del menú
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(item.text, style: const TextStyle(color: Colors.black)),
        ),
      ],
    );
  }

  /// Maneja la acción cuando se selecciona un ítem del menú
  static void onChanged(BuildContext context, MenuItem item, UserModel user) {
    switch (item) {
      case home:
        final updateUser = context.push('/editprofile', extra: {'user': user});
        if (updateUser != null) {

        }
        break;
      case share:
        context.push('/editsuscription', extra: {'user': user});
        break;
      case logout:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro que deseas cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('uid');
                  Navigator.of(context).pop();
                  context.go('/');
                },
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
        );
        break;
    }
  }
}

/// Modelo para los ítems del menú
class MenuItem {
  /// Texto que se muestra en el ítem
  final String text;

  /// Icono que se muestra en el ítem
  final IconData icon;

  /// Constructor del ítem del menú
  const MenuItem({required this.text, required this.icon});
}
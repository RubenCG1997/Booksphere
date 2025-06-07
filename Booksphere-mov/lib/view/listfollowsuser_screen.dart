import 'package:flutter/material.dart';
import 'package:booksphere/core/color.dart';
import 'package:go_router/go_router.dart';

import '../controller/user_controller.dart';
import '../model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla que muestra la lista de usuarios que el usuario actual sigue.
///
/// Permite realizar búsqueda por nombre de usuario y seguir o dejar de seguir.
class ListFollowUser extends StatefulWidget {
  /// ID del usuario actual.
  final String uid;

  /// Constructor que recibe el UID del usuario.
  const ListFollowUser({super.key, required this.uid});

  @override
  State<ListFollowUser> createState() => _ListFollowUserState();
}

/// Estado mutable de [ListFollowUser].
///
/// Administra la búsqueda, la lista de usuarios y la lógica de seguimiento.
class _ListFollowUserState extends State<ListFollowUser> {
  /// Lista de usuarios que el usuario actual sigue.
  List<UserModel> listUser = [];

  /// Controlador para el campo de búsqueda.
  final TextEditingController _searchController = TextEditingController();

  /// Indica si el campo de búsqueda tiene texto.
  bool haveText = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getListFollowUsers(); // Cargar lista de seguidos al iniciar.
  }

  @override
  Widget build(BuildContext context) {
    final loc  = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop(); // Regresa a la pantalla anterior.
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 96, 12, 21),
        title: Text(
          loc.follow_list,
          style: TextStyle(fontFamily: 'Merriweather', color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColor.backgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: kToolbarHeight * 0.7,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      haveText = _searchController.text.isNotEmpty;
                      // Filtra usuarios localmente por nombre de usuario.
                      listUser.retainWhere(
                            (user) => user.username.toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        ),
                      );
                      // Si el campo queda vacío, recarga la lista original.
                      if (!haveText) {
                        _searchController.clear();
                        _getListFollowUsers();
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
                    hintText: loc.search_placeholder,
                    hintStyle: TextStyle(
                      color: Color.fromARGB(128, 255, 255, 255),
                      fontSize: 16,
                      fontFamily: 'Merriweather',
                    ),
                    suffixIcon: haveText
                        ? GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _getListFollowUsers();
                          haveText = false;
                        });
                      },
                      child: Icon(
                        Icons.clear_rounded,
                        color: Color.fromARGB(128, 255, 255, 255),
                        size: 30,
                      ),
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
            ),
            Expanded(
              child: listUser.isNotEmpty
                  ? ListView.builder(
                itemCount: listUser.length,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder<bool>(
                    future: isFollowing(listUser[index].uid),
                    builder: (context, snapshot) {
                      bool following = snapshot.data ?? false;

                      return ListTile(
                        title: Text(
                          listUser[index].username,
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            color: AppColor.textColor,
                          ),
                        ),
                        subtitle: Text(
                          listUser[index].email,
                          style: TextStyle(
                            fontFamily: 'Merriweather',
                            color: AppColor.hintColor,
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            if (following) {
                              await UserController().unfollowUser(
                                widget.uid,
                                listUser[index].uid,
                              );
                            } else {
                              await UserController().followUser(
                                widget.uid,
                                listUser[index].uid,
                              );
                            }
                            await _getListFollowUsers();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor:
                            following ? Colors.redAccent : AppColor.smartButtonColor,
                          ),
                          child: Text(
                            following ? loc.unfollow : loc.follow,
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              )
                  : _searchController.text.isNotEmpty && listUser.isEmpty
                  ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 100,
                      color: AppColor.hintColor,
                    ),
                    Text(
                      loc.no_matches,
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontFamily: 'Merriweather',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Carga la lista de usuarios que el usuario actual sigue.
  Future<void> _getListFollowUsers() async {
    final listIdUser = await UserController().getFollowsIdUsers(widget.uid);

    List<UserModel> users = [];

    for (String idUser in listIdUser) {
      final user = await UserController().getUser(idUser);
      if (user != null) {
        users.add(user);
      }
    }

    setState(() {
      listUser = users;
    });
  }

  /// Verifica si el usuario actual sigue a [userId].
  ///
  /// Retorna `true` si lo sigue, `false` si no.
  Future<bool> isFollowing(String userId) async {
    final listIdUser = await UserController().getFollowsIdUsers(widget.uid);
    return listIdUser.contains(userId);
  }
}

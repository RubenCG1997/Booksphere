import 'package:booksphere/core/color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controller/user_controller.dart';
import '../model/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Pantalla que muestra la lista de usuarios que siguen al usuario actual.
///
/// Permite buscar usuarios por nombre y seguir o dejar de seguirlos.
class ListUser extends StatefulWidget {
  /// Identificador del usuario actual.
  final String uid;

  /// Constructor que recibe el UID del usuario.
  const ListUser({super.key, required this.uid});

  @override
  State<ListUser> createState() => _ListUserState();
}

/// Estado mutable para la pantalla [ListUser].
///
/// Controla la lista de usuarios seguidores, búsqueda y acciones de seguimiento.
class _ListUserState extends State<ListUser> {
  /// Lista de usuarios seguidores a mostrar.
  List<UserModel> listUser = [];

  /// Controlador del campo de búsqueda.
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
    // Carga inicial de los usuarios seguidores.
    _getListFollowerUsers();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Vuelve a la pantalla anterior.
            context.pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 96, 12, 21),
        title: Text(
          loc.followers_list,
          style: TextStyle(fontFamily: 'Merriweather', color: Colors.white),
        ),
      ),
      body: Container(
        color: AppColor.backgroundColor,
        width: double.infinity,
        height: double.infinity,
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
                      // Filtra la lista de usuarios según el texto de búsqueda.
                      listUser.retainWhere(
                            (user) => user.username.toLowerCase().contains(
                          _searchController.text.toLowerCase(),
                        ),
                      );
                      // Si el texto está vacío, recarga la lista original.
                      if (!haveText) {
                        _searchController.clear();
                        _getListFollowerUsers();
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
                      child: Icon(
                        Icons.clear_rounded,
                        color: Color.fromARGB(128, 255, 255, 255),
                        size: 30,
                      ),
                      onTap: () {
                        setState(() {
                          _searchController.clear();
                          _getListFollowerUsers();
                          haveText = false;
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
                            await _getListFollowerUsers();
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

  /// Obtiene la lista de usuarios que siguen al usuario actual.
  Future<void> _getListFollowerUsers() async {
    final listIdUser = await UserController().getFollowersIdUsers(widget.uid);

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
  /// Retorna `true` si el usuario sigue a [userId], `false` en caso contrario.
  Future<bool> isFollowing(String userId) async {
    final listIdUser = await UserController().getFollowsIdUsers(widget.uid);
    return listIdUser.contains(userId);
  }

}


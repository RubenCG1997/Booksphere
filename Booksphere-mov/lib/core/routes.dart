import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view/welcome_screen.dart';
import '../view/login_screen.dart';
import '../view/register_screen.dart';
import '../view/recover_password_screen.dart';
import '../view/homeMain_screen.dart';
import '../view/search_screen.dart';
import '../view/book_screen.dart';
import '../view/reader_screen.dart';
import '../view/booklist_screen.dart';
import '../view/listfollowers_screen.dart';
import '../view/listfollowsuser_screen.dart';
import '../view/editprofile_screen.dart';
import '../view/editsuscription_screen.dart';
import '../model/user_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Ruta principal - Welcome screen
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('uid');
        return uid != null ? '/home' : null;
      },
    ),

    // Login
    GoRoute(
      path: '/Login',
      builder: (context, state) => const Login(),
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final uid = prefs.getString('uid');
        return uid != null ? '/home' : null;
      },
    ),

    // Registro
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),

    // Recuperar contraseña
    GoRoute(
      path: '/recover_password',
      builder: (context, state) => const RecoverPassword(),
    ),

    // Home - requiere uid guardado en SharedPreferences
    GoRoute(
      path: '/home',
      builder: (context, state) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final prefs = snapshot.data!;
          final uid = prefs.getString('uid');
          if (uid == null) return const Welcome();
          return Home(uid: uid);
        },
      ),
    ),

    // Search - recibe String uidUser por extra
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final uidUser = state.extra as String?;
        if (uidUser == null) {
          return const Scaffold(body: Center(child: Text('UID no proporcionado')));
        }
        return Search(uidUser: uidUser);
      },
    ),

    // Book - recibe Map<String, dynamic> con keys 'isbn' y 'uid'
    GoRoute(
      path: '/book',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('isbn') || !params.containsKey('uid')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para Book')));
        }
        final isbn = params['isbn'] as String;
        final uidUser = params['uid'] as String;
        return Book(isbn: isbn, uidUser: uidUser);
      },
    ),

    // Reader - recibe Map<String, dynamic> con keys 'urlEpub' y 'uidUser'
    GoRoute(
      path: '/reader',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('urlEpub') || !params.containsKey('uidUser')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para Reader')));
        }
        final urlEpub = params['urlEpub'] as String;
        final uidUser = params['uidUser'] as String;
        return Reader(urlEpub: urlEpub, uidUser: uidUser);
      },
    ),

    // Booklist - recibe Map con 'uid' y 'name'
    GoRoute(
      path: '/booklist',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('uid') || !params.containsKey('name')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para Booklist')));
        }
        final uid = params['uid'] as String;
        final name = params['name'] as String;
        return Booklist(uid: uid, name: name);
      },
    ),

    // ListUser (seguidores) - recibe Map con 'uid'
    GoRoute(
      path: '/listfolloweruser',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('uid')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para ListUser')));
        }
        final uid = params['uid'] as String;
        return ListUser(uid: uid);
      },
    ),

    // ListFollowUser (seguidos) - recibe Map con 'uid'
    GoRoute(
      path: '/listfollowuser',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('uid')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para ListFollowUser')));
        }
        final uid = params['uid'] as String;
        return ListFollowUser(uid: uid);
      },
    ),

    // EditProfile - recibe Map con UserModel 'user'
    GoRoute(
      path: '/editprofile',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('user')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para EditProfile')));
        }
        final user = params['user'] as UserModel;
        return Editprofile(user: user);
      },
    ),

    // EditSubscription - recibe Map con UserModel 'user'
    GoRoute(
      path: '/editsuscription',
      builder: (context, state) {
        final params = state.extra as Map<String, dynamic>?;
        if (params == null || !params.containsKey('user')) {
          return const Scaffold(body: Center(child: Text('Parámetros inválidos para EditSubscription')));
        }
        final user = params['user'] as UserModel;
        return EditSubscriptionScreen(user: user);
      },
    ),
  ],
);

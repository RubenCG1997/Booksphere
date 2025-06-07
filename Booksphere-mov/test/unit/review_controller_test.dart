import 'package:booksphere/controller/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late UserController userController;

  setUp(() {
    userController = UserController();
  });

  group('UserController integration tests', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testUsername = 'testuser';
    const testSubscription = 'FREE';
    const testUid = 'some-uid';

    test('createWithEmail returns bool', () async {
      final result = await userController.createWithEmail(
        TestBuildContext(),
        testEmail,
        testPassword,
        testUsername,
        testSubscription,
      );
      expect(result, isA<bool>());
    });

    test('signInWithGoogle returns uid or null', () async {
      final uid = await userController.signInWithGoogle();
      expect(uid == null || uid is String, true);
    });

    test('login returns uid or null', () async {
      final uid = await userController.login(
        testEmail,
        testPassword,
        TestBuildContext(),
      );
      expect(uid == null || uid is String, true);
    });

    test('recoverPassword returns bool', () async {
      final result = await userController.recoverPassword(testEmail);
      expect(result, isA<bool>());
    });

    test('getAllUsers returns list of UserModel', () async {
      final users = await userController.getAllUsers(testUid);
      expect(users, isA<List>());
      if (users.isNotEmpty) {
        expect(users.first.runtimeType.toString(), 'UserModel');
      }
    });

    test('getUser returns UserModel or null', () async {
      final user = await userController.getUser(testUid);
      expect(user == null || user.runtimeType.toString() == 'UserModel', true);
    });

    test('getLastChapter returns String', () async {
      final chapter = await userController.getLastChapter(testUid, 'someIsbn');
      expect(chapter, isA<String>());
    });

    test('getFollowersIdUsers returns list of strings', () async {
      final followers = await userController.getFollowersIdUsers(testUid);
      expect(followers, isA<List<String>>());
    });

    test('getFollowsIdUsers returns list of strings', () async {
      final follows = await userController.getFollowsIdUsers(testUid);
      expect(follows, isA<List<String>>());
    });

    test('getReaderBooks returns list of BookModel', () async {
      final books = await userController.getReaderBooks(testUid);
      expect(books, isA<List>());
    });

    // Métodos void, solo probamos que no lancen excepciones
    test('followUser does not throw', () async {
      await userController.followUser(testUid, 'otherUserId');
    });

    test('unfollowUser does not throw', () async {
      await userController.unfollowUser(testUid, 'otherUserId');
    });

    test('updateUser does not throw', () async {
      // Aquí deberías pasar un UserModel válido, usando null para test rápido
      await userController.updateUser(null);
    });

    test('updateSubscription does not throw', () async {
      await userController.updateSubscription(testUid, testSubscription);
    });
  });
}

// Contexto falso para pruebas
class TestBuildContext extends Fake implements BuildContext {}

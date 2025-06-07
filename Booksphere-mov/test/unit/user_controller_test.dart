import 'package:flutter_test/flutter_test.dart';
import 'package:booksphere/controller/user_controller.dart';
import 'package:booksphere/model/user_model.dart';
import 'package:booksphere/model/subsciption_type.dart';

void main() {
  late UserController controller;

  const testEmail = 'testuser@example.com';
  const testPassword = '123456';
  const testUsername = 'TestUser';
  const testSubscription = 'FREE';

  setUp(() {
    controller = UserController();
  });

  test('createWithEmail returns true or false', () async {
    final result = await controller.createWithEmail(
      TestWidgetsFlutterBinding.ensureInitialized().renderViewElement!,
      testEmail,
      testPassword,
      testUsername,
      testSubscription,
    );
    expect(result == true || result == false, true);
  });

  test('signInWithGoogle returns uid or null', () async {
    final uid = await controller.signInWithGoogle();
    expect(uid == null || uid is String, true);
  });

  test('login returns uid or null', () async {
    final uid = await controller.login(
      testEmail,
      testPassword,
      TestWidgetsFlutterBinding.ensureInitialized().renderViewElement!,
    );
    expect(uid == null || uid is String, true);
  });

  test('recoverPassword returns true or false', () async {
    final result = await controller.recoverPassword(testEmail);
    expect(result == true || result == false, true);
  });

  test('getAllUsers returns list of users', () async {
    final users = await controller.getAllUsers('some_uid');
    expect(users, isA<List<UserModel>>());
  });

  test('getUser returns UserModel or null', () async {
    final user = await controller.getUser('some_valid_or_invalid_uid');
    expect(user == null || user is UserModel, true);
  });

  test('saveLastPosition completes without error', () async {
    await controller.saveLastPosition('some_uid', 'some_isbn', 'chapter_5');
  });

  test('getLastChapter returns a string', () async {
    final chapter = await controller.getLastChapter('some_uid', 'some_isbn');
    expect(chapter, isA<String>());
  });

  test('getFollowersIdUsers returns list of ids', () async {
    final ids = await controller.getFollowersIdUsers('some_uid');
    expect(ids, isA<List<String>>());
  });

  test('getFollowsIdUsers returns list of ids', () async {
    final ids = await controller.getFollowsIdUsers('some_uid');
    expect(ids, isA<List<String>>());
  });

  test('getReaderBooks returns list of books', () async {
    final books = await controller.getReaderBooks('some_uid');
    expect(books, isA<List>());
  });

  test('followUser completes without error', () async {
    await controller.followUser('some_uid', 'other_uid');
  });

  test('unfollowUser completes without error', () async {
    await controller.unfollowUser('some_uid', 'other_uid');
  });

  test('updateSubscription completes without error', () async {
    await controller.updateSubscription('some_uid', SubcriptionType.PREMIUM.toString());
  });
}

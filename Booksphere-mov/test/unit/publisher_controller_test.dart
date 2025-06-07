import 'package:booksphere/controller/publisher_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() {
  group('PublisherController integration tests', () {
    late PublisherController publisherController;

    setUp(() {
      // Se usa la instancia real de Firestore
      publisherController = PublisherController();
    });

    test('getNamePublisher returns publisher name if document exists', () async {
      // Aquí deberías asegurarte que el documento 'pub1' con campo 'name' existe en Firestore
      final name = await publisherController.getNamePublisher('pub1');

      // Cambia "Editorial XYZ" por el nombre esperado en Firestore
      expect(name, isNotNull);
    });

    test('getNamePublisher returns null if document does not exist', () async {
      final name = await publisherController.getNamePublisher('nonexistent_id_123456');
      expect(name, null);
    });
  });
}

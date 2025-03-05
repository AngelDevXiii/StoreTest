import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/config/models/firestore_service_error.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final docs = (await _db.collection('products').get()).docs;
      final products = docs.map((e) => {...e.data(), "uid": e.id}).toList();

      return products;
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }
}

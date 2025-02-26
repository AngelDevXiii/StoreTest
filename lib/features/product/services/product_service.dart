import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/config/firestore_service_error.dart';

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

  Future<Map<String, dynamic>?> getProduct(String productId) async {
    try {
      final product =
          (await _db.collection('products').doc(productId).get()).data();

      if (product == null) return null;

      return {...product, "uid": productId};
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (_) {
      throw const FirestoreServiceFailure();
    }
  }
}

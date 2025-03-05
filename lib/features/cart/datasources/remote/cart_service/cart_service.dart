import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/config/models/firestore_service_error.dart';

class CartGetResponse {
  final DateTime? updatedAt;
  final List<Map<String, dynamic>> cart;

  const CartGetResponse({required this.updatedAt, required this.cart});
}

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<CartGetResponse> getCart(String userId) async {
    try {
      final docRef = _db.collection('carts').doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        final newCart = {"products": []};
        await docRef.set(newCart);
      }

      final cart =
          (await docRef.collection('products').get()).docs.map((e) {
            return {...e.data()};
          }).toList();

      Timestamp? updatedAtTimestamp = doc.data()?['updatedAt'];
      DateTime? updatedAt = updatedAtTimestamp?.toDate();

      return CartGetResponse(updatedAt: updatedAt, cart: cart);
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }

  Future<void> saveCart(
    String userId,
    List<Map<String, dynamic>> products,
  ) async {
    try {
      final cartRef = _db.collection('carts').doc(userId);
      final productsCollection = cartRef.collection('products');

      final productsSnapshot = await productsCollection.get();
      for (final doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }

      for (final product in products) {
        await productsCollection.doc().set(product);
      }

      await cartRef.update({"updatedAt": FieldValue.serverTimestamp()});
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } on Exception catch (_) {
      throw const FirestoreServiceFailure();
    }
  }

  Future<void> clearCart(String userId) async {
    try {
      final cartRef = _db.collection('carts').doc(userId);

      final productsSnapshot = await cartRef.collection('products').get();
      for (var doc in productsSnapshot.docs) {
        await doc.reference.delete();
      }
      cartRef.update({"updatedAt": FieldValue.serverTimestamp()});
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }
}

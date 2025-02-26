import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/config/firestore_service_error.dart';
import 'package:store_app/features/cart/models/cart_item/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<CartItem>> streamCartProducts(String userId) {
    return FirebaseFirestore.instance
        .collection('carts')
        .doc(userId)
        .collection('products')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => CartItem.fromJson({...doc.data(), "uid": doc.id}),
                  )
                  .toList(),
        );
  }

  Future<List<Map<String, dynamic>>> getCart(String userId) async {
    try {
      final docRef = _db.collection('carts').doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        final newCart = {"products": []};
        await docRef.set(newCart);
      }

      return (await docRef.collection('products').get()).docs
          .map((e) => {...e.data(), "uid": doc.id})
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }

  Future<void> addProductToCart(
    String userId,
    Map<String, dynamic> product,
  ) async {
    try {
      final productRef = _db
          .collection('carts')
          .doc(userId)
          .collection('products')
          .doc(product['uid']);

      final doc = await productRef.get();

      if (doc.exists) {
        int quantity = product['quantity'];
        if (quantity < 1) {
          await productRef.delete();
        } else {
          await productRef.update({'quantity': quantity});
        }
      } else {
        await productRef.set(product);
      }
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }

  Future<void> deleteProductFromCart(String userId, String productId) async {
    try {
      final cartRef = _db.collection('carts').doc(userId);

      await cartRef.collection('products').doc(productId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
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
    } on FirebaseException catch (e) {
      throw FirestoreServiceFailure.fromCode(e.code);
    } catch (e) {
      throw const FirestoreServiceFailure();
    }
  }
}

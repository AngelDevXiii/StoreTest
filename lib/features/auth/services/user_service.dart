import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_app/features/auth/models/profile/profile_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserProfile(String userId) {
    return _db.collection('profiles').doc(userId).get();
  }

  Future<void> setUserProfile(String userId, Profile data) {
    return _db
        .collection('profiles')
        .doc(userId)
        .set(data.toMap(), SetOptions(merge: true));
  }

  List<Future<void>> deleteUserProfile(String userId) {
    return [
      _db.collection('profiles').doc(userId).delete(),
      _db.collection('cart').doc(userId).delete(),
    ];
  }
}

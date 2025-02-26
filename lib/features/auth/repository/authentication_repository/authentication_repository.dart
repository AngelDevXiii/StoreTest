import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:store_app/features/auth/models/user/user_model.dart';
import 'package:store_app/features/auth/services/authentication_service/authentication_service.dart';
import 'package:store_app/features/auth/services/authentication_service/firebase_authentication_service.dart';

class AuthenticationRepository {
  AuthenticationRepository({AuthenticationService? service})
    : _service = service ?? FirebaseAuthenticationService();

  final AuthenticationService _service;

  @visibleForTesting
  bool isWeb = kIsWeb;

  Stream<User> get user {
    return _service.user;
  }

  Future<void> signUp({required String email, required String password}) async {
    return _service.signUp(email: email, password: password);
  }

  Future<void> logInWithGoogle() async {
    return _service.logInWithGoogle();
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _service.logInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    return _service.logOut();
  }
}

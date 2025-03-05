import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';
import 'package:store_app/features/auth/datasources/local/user_local_datasource/user_local_datasource.dart';
import 'package:store_app/features/auth/datasources/remote/authentication_service/authentication_service.dart';
import 'package:store_app/features/auth/models/user/user_model.dart';

class AuthenticationRepository {
  AuthenticationRepository({
    required this.service,
    required this.localDataSource,
  });

  final AuthenticationService service;
  final UserLocalDataSource localDataSource;

  @visibleForTesting
  bool isWeb = kIsWeb;

  Stream<User> get user {
    return service.user.asyncMap((user) async {
      localDataSource.cacheUser(user);
      return await localDataSource.getUser();
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    return service.signUp(email: email, password: password);
  }

  Future<void> logInWithGoogle() async {
    return service.logInWithGoogle();
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return service.logInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logOut() async {
    localDataSource.clearUserCache();
    return service.logOut();
  }
}

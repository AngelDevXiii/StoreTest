import 'package:store_app/features/auth/models/user/user_model.dart';

abstract class AuthenticationService {
  Stream<User> get user;

  Future<void> signUp({required String email, required String password});

  Future<void> logInWithGoogle();

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> logOut();
}

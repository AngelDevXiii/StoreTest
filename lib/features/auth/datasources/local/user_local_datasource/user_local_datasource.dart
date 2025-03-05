import 'package:store_app/config/db/store.dart';
import 'package:store_app/features/auth/datasources/local/user_local_datasource/user_entity.dart';
import 'package:store_app/features/auth/models/user/user_model.dart';

abstract class UserLocalDataSource {
  const UserLocalDataSource();

  Future<void> cacheUser(User user);

  Future<User> getUser();

  Future<int> clearUserCache();
}

class UserObjectBoxLocalDataSource extends UserLocalDataSource {
  final ObjectBoxStore storage;

  const UserObjectBoxLocalDataSource({required this.storage});

  @override
  Future<void> cacheUser(User user) async {
    storage.userBox.removeAll();

    final cachedUser = CachedUser(
      uid: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
    );

    storage.userBox.put(cachedUser);
  }

  @override
  Future<User> getUser() async {
    final users = storage.userBox.getAll();

    final user = users.first;
    return User(
      id: user.uid,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Future<int> clearUserCache() async {
    storage.productBox.removeAll();
    storage.cartBox.removeAll();
    storage.metadataBox.removeAll();
    return storage.userBox.removeAll();
  }
}

import 'package:get_it/get_it.dart';
import 'package:store_app/config/db/store.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/auth/datasources/local/user_local_datasource/user_local_datasource.dart';
import 'package:store_app/features/auth/datasources/remote/authentication_service/authentication_service.dart';
import 'package:store_app/features/auth/datasources/remote/authentication_service/firebase_authentication_service.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';
import 'package:store_app/features/cart/datasources/local/cart_local_datasource/cart_local_datasource.dart';
import 'package:store_app/features/cart/datasources/remote/cart_service/cart_service.dart';
import 'package:store_app/features/cart/repository/cart_repository/cart_repository.dart';
import 'package:store_app/features/product/datasources/local/product_local_datasource/product_local_datasource.dart';
import 'package:store_app/features/product/datasources/remote/product_service/product_service.dart';
import 'package:store_app/features/product/repository/product_repository/product_repository.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final objectBoxStore = await ObjectBoxStore.create();
  // Secure storage injection
  getIt.registerSingleton<ObjectBoxStore>(objectBoxStore);

  // Authentication injeciton
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserObjectBoxLocalDataSource(storage: getIt<ObjectBoxStore>()),
  );

  getIt.registerLazySingleton<AuthenticationService>(
    () => FirebaseAuthenticationService(),
  );

  getIt.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepository(
      localDataSource: getIt<UserLocalDataSource>(),
      service: getIt<AuthenticationService>(),
    ),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authenticationRepository: getIt<AuthenticationRepository>()),
  );

  // Products injection

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductObjectBoxLocalDataSource(storage: getIt<ObjectBoxStore>()),
  );

  getIt.registerLazySingleton<ProductService>(() => ProductService());

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      localDataSource: getIt<ProductLocalDataSource>(),
      service: getIt<ProductService>(),
    ),
  );

  // Carts injection

  getIt.registerLazySingleton<CartLocalDataSource>(
    () => CartObjectBoxLocalDataSource(storage: getIt<ObjectBoxStore>()),
  );

  getIt.registerLazySingleton<CartService>(() => CartService());

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepository(
      localDataSource: getIt<CartLocalDataSource>(),
      service: getIt<CartService>(),
    ),
  );
}

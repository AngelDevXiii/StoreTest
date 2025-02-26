import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/auth/bloc/login_bloc/login_bloc.dart';
import 'package:store_app/features/auth/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';
import 'package:store_app/features/auth/screens/login_screen/login_screen.dart';
import 'package:store_app/features/auth/screens/sign_up_screen/sign_up_screen.dart';
import 'package:store_app/features/cart/bloc/cart/cart_bloc.dart';
import 'package:store_app/features/cart/repository/cart_repository/cart_repository.dart';
import 'package:store_app/features/cart/screen/cart_screen/cart_screen.dart';
import 'package:store_app/features/product/bloc/product_bloc.dart';
import 'package:store_app/features/product/repository/product_repository/product_repository.dart';
import 'package:store_app/features/product/screens/product_details_screen/product_details_screen.dart';
import 'package:store_app/features/product/screens/products_dashboard_screen/products_dashboard_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

getRouter(AuthBloc authBloc) => GoRouter(
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(authBloc.stream),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create:
              (context) => LoginBloc(context.read<AuthenticationRepository>()),
          child: LoginScreen(),
        );
      },
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;

        switch (authState) {
          case Authenticated():
            return '/products';
          case Unauthenticated():
            return null;
        }
      },
      routes: [
        GoRoute(
          path: '/sign-up',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create:
                  (context) =>
                      SignUpBloc(context.read<AuthenticationRepository>()),
              child: SignUpScreen(),
            );
          },
        ),
      ],
    ),

    ShellRoute(
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;

        switch (authState) {
          case Authenticated():
            return null;
          case Unauthenticated():
            return '/';
        }
      },
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CartBloc(CartRepository())),
            BlocProvider(create: (_) => ProductBloc(ProductRepository())),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/products',
          name: 'products',
          builder: (BuildContext context, GoRouterState state) {
            return const ProductsDashboardScreen();
          },
          routes: [
            GoRoute(
              name: 'details',
              path: 'details/:id',
              builder: (BuildContext context, GoRouterState state) {
                final productId = state.pathParameters["id"]; // Get parameter
                return ProductDetailsScreen(productId: productId);
              },
            ),
            GoRoute(
              name: 'cart',
              path: 'cart',
              builder: (BuildContext context, GoRouterState state) {
                return CartsScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/features/auth/repository/authentication_repository/authentication_repository.dart';
import 'package:store_app/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({required AuthBloc authBloc, super.key}) : _authBloc = authBloc;

  final AuthBloc _authBloc;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: AuthenticationRepository(),
      child: BlocProvider.value(
        value: _authBloc..add(AuthUserSubscriptionRequested()),
        child: MaterialApp.router(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            textTheme: GoogleFonts.latoTextTheme(),
          ),
          routerConfig: getRouter(_authBloc),
        ),
      ),
    );
  }
}

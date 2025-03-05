import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/config/dependency_injection/setup_locator.dart';
import 'package:store_app/features/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:store_app/router/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>()..add(AuthUserSubscriptionRequested()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.orange,
          appBarTheme: AppBarTheme(color: Colors.orange),
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          scaffoldBackgroundColor: Color.fromRGBO(255, 245, 238, 1),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.orange,

            selectionHandleColor: Colors.orange,
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.orange),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),

            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        routerConfig: getRouter(getIt<AuthBloc>()),
      ),
    );
  }
}

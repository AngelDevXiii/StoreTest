import 'package:flutter/material.dart';
import 'package:store_app/features/auth/screens/sign_up_screen/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(padding: const EdgeInsets.all(16), child: SignUpForm()),
    );
  }
}

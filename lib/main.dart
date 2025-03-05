import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:store_app/app.dart';
import 'package:store_app/config/dependency_injection/setup_locator.dart';
import 'package:store_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  await setupLocator();

  runApp(MyApp());
}

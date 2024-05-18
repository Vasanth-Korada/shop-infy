import 'package:dtdl/screens/dashboard.dart';
import 'package:dtdl/screens/strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;
  runZonedGuarded(() {
    runApp(const MyApp());
    throw Exception(AppStrings.error);
  }, (error, stackTrace) async {
    await firestore.collection('error_logs').add({
      'error_message': error.toString(),
      'stack_trace': stackTrace.toString(),
      'timestamp': DateTime.now(),
    });
  });

  // Keep the program running to listen for errors
  await Future.delayed(const Duration(days: 365));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHOP INFY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}

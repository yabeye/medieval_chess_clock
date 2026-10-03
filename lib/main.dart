import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/view/splash/app_initialization_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medieval Chess Clock',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Color(0XFF7A492F))),
      home: const AppInitializationScreen(),
    );
  }
}

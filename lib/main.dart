import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medieval_chess_clock/src/constants.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/view/splash/app_initialization_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make status bar and navigation bar completely transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge mode for modern Android devices
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(ProviderScope(child: const MedievalChessClockApp()));
}

class MedievalChessClockApp extends StatelessWidget {
  const MedievalChessClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: MedievalTheme.lightTheme,
      home: const AppInitializationScreen(),
    );
  }
}

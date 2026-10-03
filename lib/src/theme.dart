import 'package:flutter/material.dart';

class MedievalTheme {
  // 1. Define Core Colors
  static const Color primary = Color(0xFF7A492F);
  static const Color secondary = Color(0xFFB59C75);
  static const Color tertiary = Color(0xFF3A2318);
  static const Color neutral = Color(0xFFE8E2D5);
  static const Color surfaceLight = Color(
    0xFFF4F0EA,
  ); // Slightly lighter for cards
  static const Color white = Colors.white;

  // 2. Define Color Scheme
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: white,
    secondary: secondary,
    onSecondary: tertiary,
    tertiary: tertiary,
    onTertiary: white,
    surface: neutral,
    onSurface: tertiary,
    error: Colors.redAccent,
    onError: white,
  );

  // 3. Define Typography
  static final TextTheme _textTheme = const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontFamily: 'EBGaramond',
      color: tertiary,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: 'SpaceGrotesk',
      color: tertiary,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'SpaceGrotesk',
      color: tertiary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'SpaceGrotesk',
      color: tertiary,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      fontFamily: 'SpaceGrotesk',
      color: white,
      fontWeight: FontWeight.bold,
    ), // Button text
    labelSmall: TextStyle(
      fontFamily: 'SpaceGrotesk',
      color: tertiary,
      letterSpacing: 1.2,
    ), // Uppercase labels
  );

  // 4. Build ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: neutral,
      textTheme: _textTheme,

      // AppBar Styling
      appBarTheme: AppBarTheme(
        backgroundColor: tertiary.withValues(alpha: .1),
        foregroundColor: tertiary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: tertiary),
        titleTextStyle: TextStyle(
          fontFamily: 'EBGaramond',
          color: tertiary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Button Styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Slight rounding
          ),
          textStyle: _textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tertiary,
          side: const BorderSide(color: secondary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Card / Container Styling
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: secondary.withOpacity(0.3),
            width: 1,
          ), // Subtle border
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),

      // Input Styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondary.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: secondary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: _textTheme.bodyMedium?.copyWith(color: secondary),
      ),

      // Switch / Toggle Styling
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return secondary;
          return neutral;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return secondary.withOpacity(0.5);
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A utility class that defines the application's visual theme.
class AppTheme {
  // Private constructor to prevent instantiation.
  AppTheme._();

  /// The primary light theme for the application.
  static final ThemeData lightTheme = ThemeData(
    // Use Material 3 design principles
    useMaterial3: true,

    // Define the color scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),

    // Define AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, // Prevents color change on scroll
      elevation: 2.0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto', // Example of using a custom font
      ),
    ),

    // Define text input field theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
    ),

    // Define ElevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color
        backgroundColor: Colors.blue, // Button background color
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        elevation: 2,
      ),
    ),

    // Define Card theme
    cardTheme: CardTheme(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    // Define general typography
    textTheme: const TextTheme(
      headlineMedium:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 16, height: 1.5),
    ),
  );
}

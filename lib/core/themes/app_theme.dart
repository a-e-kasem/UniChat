import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[100],
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: Colors.black),
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      selectedLabelStyle: TextStyle(color: Colors.black),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyLarge: GoogleFonts.inter(color: Colors.black),
      bodyMedium: GoogleFonts.inter(color: Colors.black),
      titleLarge: GoogleFonts.inter(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: GoogleFonts.inter(color: Colors.black),
      titleSmall: GoogleFonts.inter(color: Colors.black),
    ),
    primarySwatch: createMaterialColor(Colors.black),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[800],
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.grey),
      selectedLabelStyle: TextStyle(color: Colors.white),
      unselectedLabelStyle: TextStyle(color: Colors.grey),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      bodyLarge: GoogleFonts.inter(color: Colors.white),
      bodyMedium: GoogleFonts.inter(color: Colors.white),
      titleLarge: GoogleFonts.inter(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleMedium: GoogleFonts.inter(color: Colors.white),
      titleSmall: GoogleFonts.inter(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.white,
      brightness: Brightness.dark,
    ),
    primarySwatch: createMaterialColor(Colors.white),
  );
}

/// Create a custom MaterialColor from a single Color
MaterialColor createMaterialColor(Color color) {
  return MaterialColor(color.value, <int, Color>{
    50: color.withOpacity(.05),
    100: color.withOpacity(.1),
    200: color.withOpacity(.2),
    300: color.withOpacity(.3),
    400: color.withOpacity(.4),
    500: color.withOpacity(.5),
    600: color.withOpacity(.6),
    700: color.withOpacity(.7),
    800: color.withOpacity(.8),
    900: color.withOpacity(.9),
  });
}

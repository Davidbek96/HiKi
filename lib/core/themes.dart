import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo,
  surface: const Color(0xFFF3F4F6), //scaffold background
);

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 1125),
  brightness: Brightness.dark,
  onPrimary: Colors.white,
);

class Themes {
  ThemeData lightThemeData = ThemeData().copyWith(
    scaffoldBackgroundColor: kColorScheme.surface,
    colorScheme: kColorScheme,
    appBarTheme: const AppBarTheme().copyWith(
      backgroundColor: Colors.transparent,
      foregroundColor: kColorScheme.primaryContainer,
    ),
    inputDecorationTheme: InputDecorationTheme().copyWith(
      labelStyle: TextStyle().copyWith(
        color: Colors.grey, // Set the color for all label text
        fontSize: 16,
      ),
    ),
    cardTheme: CardTheme(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      color: Colors.white.withValues(alpha: 0.6),
      elevation: 0,
      shadowColor: Colors.transparent,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      shape: const StadiumBorder(), //make it circler
      iconSize: 30,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorScheme.primaryContainer,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle().copyWith(
        iconColor: WidgetStatePropertyAll(Colors.grey.shade600),
      ),
    ),
    textTheme: ThemeData().textTheme.copyWith(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            color: kColorScheme.tertiary,
            fontSize: 30,
          ),
          labelLarge: const TextStyle(
            color: Color.fromARGB(255, 59, 61, 62),
          ),
          displaySmall: TextStyle(
            color: kColorScheme.onPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 30,
          ),
          titleSmall: TextStyle(
            color: kColorScheme.onPrimary,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w600,
            color: kColorScheme.onPrimary,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w500,
            color: kColorScheme.inverseSurface.withAlpha(240),
          ),
          // bodySmall: TextStyle().copyWith(
          //   color: Colors.black54,
          // ),
        ),
    iconTheme: const IconThemeData().copyWith(
      color: Colors.white,
    ),
  );

  ThemeData darkThemeData = ThemeData.dark().copyWith(
    colorScheme: kDarkColorScheme,
    textTheme: ThemeData.dark().textTheme.copyWith(
          titleLarge: TextStyle(
            color: kDarkColorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
    cardTheme: const CardTheme().copyWith(
      color: kDarkColorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kDarkColorScheme.primaryContainer,
        foregroundColor: kDarkColorScheme.onPrimaryContainer,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      shape: const StadiumBorder(), //make it circler
      iconSize: 30,
    ),
    appBarTheme: AppBarTheme().copyWith(
      backgroundColor: Colors.transparent,
    ),
  );
}

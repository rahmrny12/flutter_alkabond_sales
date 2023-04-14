import 'package:flutter/material.dart';

class CustomTheme {
  static light() => ThemeData(
        textTheme: const TextTheme(
          headline2: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          headline3: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
          headline4: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          headline5: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          headline6: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        colorScheme: const ColorScheme(
          primary: Color(0xFF6D5D6E),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFFF4EEE0),
          onSecondary: Color(0xFF1E1E1E),
          error: Color(0xFFFF0033),
          onError: Color(0xFFFFFFFF),
          background: Color(0xFF433C48),
          onBackground: Color(0xFFAEAEAE),
          surface: Color(0xFFFFECBF),
          onSurface: Color(0xFF322D35),
          brightness: Brightness.light,
        ),
      );
}
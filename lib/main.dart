import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/converter_screen.dart';
import 'screens/base64_screen.dart';
import 'screens/json_formatter_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (portrait only for calculator UX)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const DevCalApp());
}

/// Root widget for the DEVCal application.
///
/// Configures Material 3 theming with light and dark modes,
/// Google Fonts typography, and named route navigation.
class DevCalApp extends StatelessWidget {
  const DevCalApp({super.key});

  // Brand colors
  static const Color _primaryColor = Color(0xFF1E88E5);
  static const Color _lightBackground = Color(0xFFF5F7FA);
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E2E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DEVCal',
      debugShowCheckedModeBanner: false,

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: _primaryColor,
        scaffoldBackgroundColor: _lightBackground,
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: _lightBackground,
          foregroundColor: const Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
            letterSpacing: -0.3,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: _primaryColor,
        scaffoldBackgroundColor: _darkBackground,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: _darkBackground,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardThemeData(
          color: _darkSurface,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()},
        ),
      ),

      // Follow system dark mode setting
      themeMode: ThemeMode.system,

      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/calculator': (context) => const CalculatorScreen(),
        '/converter': (context) => const ConverterScreen(),
        '/base64': (context) => const Base64Screen(),
        '/json-formatter': (context) => const JsonFormatterScreen(),
      },
    );
  }
}

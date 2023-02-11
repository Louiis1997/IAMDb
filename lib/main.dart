import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'common/router.dart';

const storage = FlutterSecureStorage();

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load();
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'IAMDb';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          // surface: Color.fromRGBO(244, 197, 24, 1),
          surface: Color.fromRGBO(255, 255, 255, 1),
          onSurface: Color.fromRGBO(0, 0, 0, 1),
          // Colors that are not relevant to AppBar in DARK mode:
          primary: Color.fromRGBO(244, 197, 24, 1),
          onPrimary: Color.fromRGBO(0, 0, 0, 1),
          secondary: Colors.grey,
          onSecondary: Colors.grey,
          background: Color.fromRGBO(255, 255, 255, 0.8),
          onBackground: Colors.grey,
          error: Color.fromRGBO(255, 0, 0, 1),
          onError: Color.fromRGBO(244, 197, 24, 1),
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(244, 197, 24, 1),
            ),
          ),
          headline2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          bodyText1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 1),
            ),
          ),
          bodyText2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(0, 0, 0, 0.7),
            ),
          ),
          subtitle2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color.fromRGBO(0, 0, 0, 1),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color.fromRGBO(244, 197, 24, 1),
              width: 2,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(200, 200, 200, 0.8),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: const Color.fromRGBO(244, 197, 24, 1),
        ),
        cardColor: const Color.fromRGBO(230, 230, 230, 0.8),
        primaryColor: const Color.fromRGBO(244, 197, 24, 1),
        primaryColorLight: const Color.fromRGBO(
            255, 223, 99, 1.0),
        secondaryHeaderColor: const Color.fromRGBO(255, 240, 178, 1.0),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          // surface: Color.fromRGBO(244, 197, 24, 1),
          surface: Color.fromRGBO(40, 40, 40, 1),
          onSurface: Color.fromRGBO(0, 0, 0, 1),
          // Colors that are not relevant to AppBar in DARK mode:
          primary: Color.fromRGBO(244, 197, 24, 1),
          onPrimary: Color.fromRGBO(0, 0, 0, 1),
          secondary: Color.fromRGBO(244, 197, 24, 1),
          onSecondary: Colors.grey,
          background: Color.fromRGBO(255, 255, 255, 0.8),
          onBackground: Colors.grey,
          error: Color.fromRGBO(255, 0, 0, 1),
          onError: Color.fromRGBO(244, 197, 24, 1),
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(244, 197, 24, 1),
            ),
          ),
          headline2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          bodyText1: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
          bodyText2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 0.7),
            ),
          ),
          subtitle2: GoogleFonts.roboto(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Color.fromRGBO(0, 0, 0, 1),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Color.fromRGBO(244, 197, 24, 1),
              width: 2,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(30, 30, 30, 0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          backgroundColor: const Color.fromRGBO(244, 197, 24, 1),
        ),
        cardColor: const Color.fromRGBO(30, 30, 30, 0.8),
        primaryColor: const Color.fromRGBO(244, 197, 24, 1),
        primaryColorLight: const Color.fromRGBO(
            255, 223, 99, 1.0),
      ),
      themeMode: ThemeMode.light,
      routes: MyRouter.routes(),
      onGenerateRoute: MyRouter.getRouter,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

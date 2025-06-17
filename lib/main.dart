import 'package:flutter/material.dart';
import 'package:songbooksofpraise_app/HomePage/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(132, 14, 23, 1.0);

    return MaterialApp(
      title: 'Songbooks of Praise',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color.fromRGBO(248, 245, 237, 1.0),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        iconTheme: const IconThemeData(color: primaryColor),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color.fromRGBO(140, 147, 159, 1),
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromRGBO(221, 225, 229, 1),
              width: 1.0,
            ),
          ),
          fillColor: Color.fromRGBO(248, 249, 251, 1),
          filled: true,
          contentPadding: EdgeInsets.all(10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color.fromRGBO(248, 249, 251, 1), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: Color.fromRGBO(140, 147, 159, 1),
          unselectedLabelStyle: TextStyle(fontSize: 14.0),
          selectedLabelStyle: TextStyle(fontSize: 14.0),
          // selectedIconTheme: IconThemeData(size: 28.0),
          // unselectedIconTheme: IconThemeData(size: 24.0),
        ),
      ),
      home: const HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songbooksofpraise_app/Providers/SettingsProvider.dart';
import 'package:songbooksofpraise_app/pages/HomePage/HomePage.dart';
import 'package:songbooksofpraise_app/components/SlideInFromRightPageBuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the ThemeProvider with stored preferences if available

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final textSize = prefs.getString('textSize') ?? 'medium';
  final brightness = prefs.getString('brightness') == 'dark' ? Brightness.dark : Brightness.light;
  final keepScreenOn = prefs.getBool('keepScreenOn') ?? true;
  final defaultTranspose = prefs.getInt('defaultTranspose') ?? 0;
  final showChordsByDefault = prefs.getBool('showChordsByDefault') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(
        textSize: SettingsProviderTextSize.values.firstWhere(
          (e) => e.name == textSize,
          orElse: () => SettingsProviderTextSize.medium,
        ),
        brightness: brightness,
        keepScreenOn: keepScreenOn,
        defaultTranspose: defaultTranspose,
        showChordsByDefault: showChordsByDefault,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(132, 14, 23, 1.0);
    final textScaleFactor = context.watch<SettingsProvider>().textSize == SettingsProviderTextSize.small
        ? 0.9
        : context.watch<SettingsProvider>().textSize == SettingsProviderTextSize.large
            ? 1.2
            : 1.0;

    final brightness = context.watch<SettingsProvider>().brightness;

    return MaterialApp(
      title: 'Songbooks of Praise',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: SlideInFromRightPageBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        fontFamily: 'Inter',
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color.fromRGBO(248, 245, 237, 1.0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        iconTheme: const IconThemeData(color: primaryColor),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primaryIconTheme: const IconThemeData(
          color: primaryColor,
        ),
        textTheme: TextTheme(
          labelLarge: TextStyle(
            color: Colors.grey[700],
          ),
          labelMedium: TextStyle(
            color: Colors.grey[700],
          ),
          labelSmall: TextStyle(
            color: Colors.grey[700],
          ),
        ),
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
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(
            // color: Colors.grey[700],
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            constraints: BoxConstraints.expand(height: 40.0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          ),
          menuStyle: MenuStyle(
            maximumSize: WidgetStateProperty.all<Size>(const Size(double.infinity, double.infinity)),
            minimumSize: WidgetStateProperty.all<Size>(const Size(double.infinity, 0)),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScaleFactor)),
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}

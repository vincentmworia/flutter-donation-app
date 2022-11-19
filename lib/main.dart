import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appTitle = 'Blood App';
  static const primaryColor = Color.fromRGBO(136, 8, 8, 1);
  static const secondaryColor = Color.fromRGBO(30, 41, 82, 1);
  static const defaultScreen = AuthScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 65,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 22.0,
            color: secondaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 5.0,
          ),
        ).copyWith(iconTheme: const IconThemeData(color: secondaryColor)),
      ),
      home: defaultScreen,
      routes: {
        AuthScreen.routeName: (_) => const AuthScreen(),
      },
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (_) => MyApp.defaultScreen,
      ),
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => MyApp.defaultScreen,
      ),
    );
  }
}
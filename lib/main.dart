import 'package:bloodbankapp/providers/fetch_firebase_data.dart';
import 'package:bloodbankapp/providers/logged_in_user.dart';
import 'package:bloodbankapp/screens/blood_groups_data.dart';
import 'package:bloodbankapp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';

void main() {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoggedInUser()),
        ChangeNotifierProvider(create: (_) => FetchFirebaseData()),
      ],
      child: MaterialApp(
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
              color: Colors.white,
              // color: secondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.0,
            ),
          ).copyWith(
              iconTheme: const IconThemeData(color: Colors.white, size: 30)),
        ),
        home: defaultScreen,
        routes: {
          AuthScreen.routeName: (_) => const AuthScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          BloodGroupsData.routeName:(_)=>const  BloodGroupsData( )
        },
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => MyApp.defaultScreen,
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (_) => MyApp.defaultScreen,
        ),
      ),
    );
  }
}

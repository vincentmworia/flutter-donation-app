import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../modules/donors.dart';
import '../private_data.dart';
import '../screens/auth_screen.dart';

class FirebaseAuthenticationHandler with ChangeNotifier {
  // todo, token expire? force log out and reset preferences
  static Uri _urlAuth(String operation) => Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:${operation}key=$webApiKey');

  static String getErrorMessage(String errorTitle) {
    var message = 'Operation failed';

    if (errorTitle.contains('EMAIL_EXISTS')) {
      message = 'Email is already in use';
    }
    if (errorTitle.contains('CREDENTIAL_TOO_OLD_LOGIN_AGAIN')) {
      message = 'Select a new email';
    } else if (errorTitle.contains('INVALID_EMAIL')) {
      message = 'This is not a valid email address';
    } else if (errorTitle.contains('NOT_ALLOWED')) {
      message = 'User needs to be allowed by the admin';
    } else if (errorTitle.contains('TOO_MANY_ATTEMPTS_TRY_LATER:')) {
      message =
          'We have blocked all requests from this device due to unusual activity. Try again later.';
    } else if (errorTitle.contains('EMAIL_NOT_FOUND')) {
      message = 'Could not find a user with that email.';
    } else if (errorTitle.contains('WEAK_PASSWORD')) {
      message = 'Password must be at least 6 characters';
    } else if (errorTitle.contains('INVALID_PASSWORD')) {
      message = 'Invalid password';
    } else {
      message = message;
    }
    return message;
  }

  static Future<String> signup(
      {required BuildContext context, required Donor donor}) async {
    String? message;
    final response = await http.post(_urlAuth('signUp?'),
        body: json.encode({
          "email": donor.email,
          "password": donor.password,
          "returnSecureToken": true,
        }));
    print("Attempt signup");
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData['error'] != null) {
      message = getErrorMessage(responseData['error']['message']);
      return message;
    } else {
      await http.patch(Uri.parse('$firebaseUrl/users.json'),
          body: json.encode({
            "${responseData['localId']}": {
              'localId': responseData['localId'],
              'email': donor.email,
              'full_name': donor.fullName,
              'age': donor.age,
              'gender': donor.gender == Gender.male ? "Male" : "Female",
              'blood_type': donor.bloodType,
              'location': donor.location,
              'password': donor.password,
            },
          })) /* .then((_) =>*/ /* _token = null*/ /*)*/;
    }
    print("message");
    message = 'Welcome,\n${donor.fullName}';
    return message;
  }

  static Future<String> login(
      {required BuildContext context, required Donor donor}) async {
    String message;

    print("attempt");
    final response = await http.post(_urlAuth('signInWithPassword?'),
        body: json.encode({
          "email": donor.email,
          "password": donor.password,
          "returnSecureToken": true,
        }));

    print(response.body);
    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData['error'] != null) {
      message = getErrorMessage(responseData['error']['message']);
      return message;
    }

    message = 'Welcome';
    print(message);
    return message;
  }

  // todo logout
  static Future<void> logout(BuildContext context) async {
    Navigator.pushReplacementNamed(context, AuthScreen.routeName);
  }
}

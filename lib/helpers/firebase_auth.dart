import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../modules/donors.dart';
import '../modules/logged_user.dart';
import '../private_data.dart';
import '../providers/logged_in_user.dart';
import '../widgets/input_field.dart';

enum ReturnCode {
  successful,
  failed,
}

class FirebaseAuthenticationHandler with ChangeNotifier {
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

  static Future<String> signupHospitalUser(
      {required BuildContext context, required Donor donor}) async {
    String? message;
    final response = await http.post(_urlAuth('signUp?'),
        body: json.encode({
          "email": donor.email,
          "password": donor.password,
          "returnSecureToken": true,
        }));
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData['error'] != null) {
      message = getErrorMessage(responseData['error']['message']);
      return message;
    } else {
      await http.patch(Uri.parse('$firebaseUrl/users/hospitalUsers.json'),
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
              'authorized': InputField.allowedInApp,
            },
          }));
    }
    message = 'Welcome,\n${donor.fullName}';
    return message;
  }

  static Future<String> signupDonor(
      {required BuildContext context, required Donor donor}) async {
    String? message;
    final phoneKey = donor.phoneNumber.toString();

    try {
      await http.patch(Uri.parse('$firebaseUrl/users/donors.json'),
          body: json.encode({
            phoneKey: {
              'email': donor.email,
              'full_name': donor.fullName,
              'age': donor.age,
              'gender': donor.gender == Gender.male ? "Male" : "Female",
              'blood_type': donor.bloodType,
              'location': donor.location,
            },
          }));
      message = 'Welcome,\n${donor.fullName}';
      return message;
    } catch (e) {
      message = e.toString();
      return message;
    }
  }

  static Future<String> login(
      {required BuildContext context, required Donor donor}) async {
    String message;
    final response = await http.post(_urlAuth('signInWithPassword?'),
        body: json.encode({
          "email": donor.email,
          "password": donor.password,
          "returnSecureToken": true,
        }));

    final responseData = json.decode(response.body) as Map<String, dynamic>;

    if (responseData['error'] != null) {
      message = getErrorMessage(responseData['error']['message']);
      return message;
    }

    final data =
        await http.get(Uri.parse('$firebaseUrl/users/hospitalUsers.json'));
    final jsonData = json.decode(data.body) as Map<String, dynamic>;
    LoggedUser? usr;
    jsonData.forEach((key, value) {
      if (donor.email == value['email']) {
        usr = LoggedUser(
          id: value['localId'],
          email: value["email"],
          fullName: value["full_name"],
          gender: value["gender"],
          allowedInApp:
              value["authorized"] == InputField.allowedInApp ? true : false,
        );
        Provider.of<LoggedInUser>(context, listen: false).setLoggedUser(usr);
      }
    });
    if (!(usr!.allowedInApp)) {
      return "User not allowed in the app";
    }

    message = 'Welcome';

    return message;
  }

  static Future<ReturnCode> logout(BuildContext context) async {
    try {
      print("try");
      Provider.of<LoggedInUser>(context,listen: false).setLoggedUser(null);
      return ReturnCode.successful;
    } catch (e) {
      print(e.toString());
      return ReturnCode.failed;
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/firebase_auth.dart';
import '../modules/donors.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/input_field.dart';
import 'home_screen.dart';

enum AuthenticationMode {
  login,
  signupDonor,
  signupHospitalUser,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = "/login_screen";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthenticationMode _authenticationMode = AuthenticationMode.login;
  final _donor = Donor();

  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var _visible = true;
  var _isLoading = false;

  // var _gender = "";
  // var _bloodGroup = "";
  static const fadeClr = 0.25;

  Widget _genderGrpButton(double op, Gender title, IconData icon) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(op)),
          icon: Icon(icon),
          onPressed: () {
            setState(() {
              _donor.gender = title;
            });
          },
          label: Text(title == Gender.male ? "Male" : "Female"));

  _showSnackBar(String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    ));
  }

  Widget _bloodGrpButton(double op, String title, IconData icon) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(op)),
          icon: Icon(icon),
          onPressed: () {
            setState(() {
              _donor.bloodType = title;
            });
          },
          label: Text(title));

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return;
    }

    if (_authenticationMode == AuthenticationMode.signupDonor) {
      if ((_donor.gender == null) && (_donor.bloodType == null)) {
        _showSnackBar("Select Gender and Blood Type");
        return;
      }
      if (_donor.gender == null) {
        _showSnackBar("Select Gender");
        return;
      }
      if (_donor.bloodType == null) {
        _showSnackBar("Select Blood Type");
        return;
      }
    }
    _formKey.currentState!.save();
    _donor.email?.trim();
    _donor.fullName?.trim();
    _donor.phoneNumber?.trim();
    _donor.age?.trim();
    _donor.location?.trim();
    _donor.password?.trim();

    if (kDebugMode) {
      print('''
    $_authenticationMode

    ${_donor.email}
    ${_donor.fullName}
    ${_donor.phoneNumber}
    ${_donor.age}
    ${_donor.location}
    ${_donor.bloodType}
    ${_donor.gender}
    ${_donor.password}
    
    ''');
    }



    //
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authenticationMode == AuthenticationMode.login) {
        if (kDebugMode) {
          print("Logging in");
        }
        await FirebaseAuthenticationHandler.login(
                context: context, donor: _donor)
            .then((message) async{
              if(message.contains("Welcome")){
                Navigator.pushReplacementNamed(
                  context,
                  HomeScreen.routeName,
                );
              }else{

                setState(() {
                  _isLoading = false;
                });
                await customDialog(context, message);
              }
        });
      } else if (_authenticationMode == AuthenticationMode.signupDonor) {
        if (kDebugMode) {
          print("Sigining up Donor");
        }
        await FirebaseAuthenticationHandler.signupDonor(
                context: context, donor: _donor)
            .then((message) async {
          setState(() {
            _isLoading = false;
          });
          await customDialog(context, message);
        });
      } else if (_authenticationMode == AuthenticationMode.signupHospitalUser) {
        await FirebaseAuthenticationHandler.signupHospitalUser(
                context: context, donor: _donor)
            .then((message) async {
          setState(() {
            _isLoading = false;
          });
          await customDialog(context, message);
        });
      }
    } catch (error) {
      const errorMessage = 'Failed, check the internet connection later';
      return await customDialog(context, errorMessage);
    } finally {
      setState(() {
        if(!(_authenticationMode ==AuthenticationMode.signupDonor)){
          _authenticationMode = AuthenticationMode.login;
        }
        if (_isLoading) {
          _isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(1),
        body: Stack(
          alignment: Alignment.center,
          children: [
            containerStyled(context),
            SingleChildScrollView(
              child: SizedBox(
                // height: _authenticationMode == AuthenticationMode.login
                //     ? deviceHeight
                //     : deviceHeight * 1.5,
                height: _authenticationMode == AuthenticationMode.login
                    ? deviceHeight
                    :_authenticationMode == AuthenticationMode.signupHospitalUser
                    ? deviceHeight*1.2
                    : 1400,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    AnimatedContainer(
                      height: deviceHeight*0.25,
                      duration: const Duration(milliseconds: 300),
                      margin: _authenticationMode == AuthenticationMode.login
                          ? EdgeInsets.only(
                              top: deviceHeight * 0.1,
                              bottom: deviceHeight * 0.1,
                            )
                          : EdgeInsets.only(
                              top: deviceHeight * 0.05,
                              bottom: deviceHeight * 0.05,
                            ),
                      padding:
                          EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
                      child: Image.asset(
                        "images/logo2.png",
                        fit: BoxFit.cover,
                      ),
                      // decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                    ),
                    Visibility(
                      visible: _visible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InputField(
                            key: const ValueKey('email'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'Email',
                            icon: Icons.account_box,
                            obscureText: false,
                            focusNode: _emailFocusNode,
                            autoCorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus((_authenticationMode ==
                                            AuthenticationMode
                                                .signupHospitalUser ||
                                        _authenticationMode ==
                                            AuthenticationMode.signupDonor)
                                    ? _fullNameFocusNode
                                    : _passwordFocusNode),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _donor.email = value!;
                            },
                          ),
                          if ((_authenticationMode ==
                                  AuthenticationMode.signupDonor ||
                              _authenticationMode ==
                                  AuthenticationMode.signupHospitalUser))
                            Column(
                              children: [
                                InputField(
                                  key: const ValueKey('fullName'),
                                  keyboardType: TextInputType.name,
                                  controller: _fullNameController,
                                  hintText: 'Full Name',
                                  icon: Icons.person,
                                  obscureText: false,
                                  focusNode: _fullNameFocusNode,
                                  autoCorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context)
                                          .requestFocus(_phoneNumberFocusNode),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Full Name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _donor.fullName = value!;
                                  },
                                ),
                                InputField(
                                  key: const ValueKey('phoneNumber'),
                                  controller: _phoneNumberController,
                                  hintText: 'Phone Number',
                                  keyboardType: TextInputType.number,
                                  icon: Icons.local_phone,
                                  obscureText: false,
                                  focusNode: _phoneNumberFocusNode,
                                  autoCorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).requestFocus(
                                          _authenticationMode ==
                                                  AuthenticationMode
                                                      .signupHospitalUser
                                              ? _passwordFocusNode
                                              : _ageFocusNode),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Phone Number';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Invalid number';
                                    }
                                    if (value.startsWith("+254")) {
                                      return 'Use 0700000000 format';
                                    }
                                    if (value.length != 10) {
                                      return 'Use 0700000000 format';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _donor.phoneNumber = value!;
                                  },
                                ),
                                if (_authenticationMode ==
                                    AuthenticationMode.signupDonor)
                                  InputField(
                                    key: const ValueKey('age'),
                                    controller: _ageController,
                                    hintText: 'Age',
                                    keyboardType: TextInputType.number,
                                    icon: Icons.timer,
                                    obscureText: false,
                                    focusNode: _ageFocusNode,
                                    autoCorrect: false,
                                    enableSuggestions: false,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_locationFocusNode),
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Age';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Invalid Age';
                                      }
                                      if (value.startsWith("-")) {
                                        return 'Invalid Age';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _donor.age = value!;
                                    },
                                  ),
                                if (_authenticationMode ==
                                    AuthenticationMode.signupDonor)
                                  InputField(
                                    key: const ValueKey('location'),
                                    controller: _locationController,
                                    hintText: 'Location Name',
                                    keyboardType: TextInputType.text,
                                    icon: Icons.location_on,
                                    obscureText: false,
                                    focusNode: _locationFocusNode,
                                    autoCorrect: false,
                                    enableSuggestions: false,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Location';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _donor.location = value!;
                                    },
                                  ),
                              ],
                            ),

                          if (
                          _authenticationMode ==
                              AuthenticationMode.signupHospitalUser||_authenticationMode ==
                              AuthenticationMode.login)
                          InputField(
                            key: const ValueKey('password'),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock,
                            obscureText: true,
                            focusNode: _passwordFocusNode,
                            autoCorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus((
                                        _authenticationMode ==
                                            AuthenticationMode
                                                .signupHospitalUser)
                                    ? _confirmPasswordFocusNode
                                    : null),
                            textInputAction: (
                                    _authenticationMode ==
                                        AuthenticationMode.signupHospitalUser)
                                ? TextInputAction.next
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid password.';
                              }
                              if (value.length < 7) {
                                return 'Password must be at least 7 characters long';
                              }
                              if (_passwordController.text
                                          .toLowerCase()
                                          .trim() ==
                                      _fullNameController.text
                                          .toLowerCase()
                                          .trim() ||
                                  _passwordController.text
                                          .toLowerCase()
                                          .trim() ==
                                      _ageController.text
                                          .toLowerCase()
                                          .trim() ||
                                  _passwordController.text
                                          .toLowerCase()
                                          .trim() ==
                                      _emailController.text
                                          .toLowerCase()
                                          .trim()) {
                                return 'Password must be different from email and name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _donor.password = value!;
                            },
                          ),
                          if (
                              _authenticationMode ==
                                  AuthenticationMode.signupHospitalUser)
                            InputField(
                              key: const ValueKey('confirmPassword'),
                              controller: _confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              hintText: 'Confirm Password',
                              icon: Icons.lock,
                              obscureText: true,
                              focusNode: _confirmPasswordFocusNode,
                              autoCorrect: false,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.none,
                              // onFieldSubmitted: (_) =>
                              //     FocusScope.of(context).requestFocus(null),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid password.';
                                }
                                if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          if ((_authenticationMode ==
                              AuthenticationMode.signupDonor))
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              width: deviceWidth * 0.85,
                              height: 120,
                              child: Column(
                                children: [
                                  const Text(
                                    "Select Gender",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _genderGrpButton(
                                            _donor.gender == Gender.male
                                                ? 1.0
                                                : fadeClr,
                                            Gender.male,
                                            Icons.male),
                                        _genderGrpButton(
                                            _donor.gender == Gender.female
                                                ? 1.0
                                                : fadeClr,
                                            Gender.female,
                                            Icons.female),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if ((_authenticationMode ==
                              AuthenticationMode.signupDonor))
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              width: deviceWidth * 0.85,
                              height: 250,
                              child: Column(
                                children: [
                                  const Text(
                                    "Select Blood Group",
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _bloodGrpButton(
                                                _donor.bloodType == "O -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "O -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _donor.bloodType == "O +"
                                                    ? 1.0
                                                    : fadeClr,
                                                "O +",
                                                Icons.bloodtype),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _bloodGrpButton(
                                                _donor.bloodType == "A -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "A -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _donor.bloodType == "A +"
                                                    ? 1.0
                                                    : fadeClr,
                                                "A +",
                                                Icons.bloodtype),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _bloodGrpButton(
                                                _donor.bloodType == "B -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "B -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _donor.bloodType == "B +"
                                                    ? 1.0
                                                    : fadeClr,
                                                "B +",
                                                Icons.bloodtype),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _bloodGrpButton(
                                                _donor.bloodType == "AB -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "AB -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _donor.bloodType == "AB +"
                                                    ? 1.0
                                                    : fadeClr,
                                                "AB +",
                                                Icons.bloodtype),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150, 65)),
                            onPressed: _submit,
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                                : _authenticationMode ==
                                        AuthenticationMode.signupDonor
                                    ? const Text("Register Donor")
                                    : _authenticationMode ==
                                            AuthenticationMode
                                                .signupHospitalUser
                                        ? const Text("Register User")
                                        : const Text("Login"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: deviceHeight * 0.05),
                      width: deviceWidth * 0.8,
                      // height: 100,
                      child: Row(
                        mainAxisAlignment:
                            (_authenticationMode == AuthenticationMode.login)
                                ? MainAxisAlignment.spaceEvenly
                                : MainAxisAlignment.center,
                        children: [
                          if (_authenticationMode == AuthenticationMode.login)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _visible = false;

                                    _authenticationMode =
                                        AuthenticationMode.signupHospitalUser;
                                  });
                                  Future.delayed(
                                          const Duration(milliseconds: 300))
                                      .then((value) => setState(() {}))
                                      .then((value) => setState(() {
                                            _visible = true;
                                          }));
                                },
                                child: Text(
                                  "Register User",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _visible = false;

                                  _authenticationMode ==
                                          AuthenticationMode.login
                                      ? _authenticationMode =
                                          AuthenticationMode.signupDonor
                                      : _authenticationMode =
                                          AuthenticationMode.login;
                                });
                                Future.delayed(
                                        const Duration(milliseconds: 300))
                                    .then((value) => setState(() {}))
                                    .then((value) => setState(() {
                                          _visible = true;
                                        }));
                              },
                              child: Text(
                                _authenticationMode == AuthenticationMode.login
                                    ? "Register Donor"
                                    : "Login User",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _fullNameFocusNode.dispose();
    _ageFocusNode.dispose();
    _locationFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }
}

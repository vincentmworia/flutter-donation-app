import 'package:bloodbankapp/modules/donors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_widgets.dart';
import '../widgets/input_field.dart';
import 'home_screen.dart';

enum AuthenticationMode {
  login,
  signup,
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
  final _genderController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final _bloodTypeFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var _visible = true;
  var _isLoading = false;
  var _gender = "";
  var _bloodGroup = "";
  static const fadeClr = 0.25;

  Widget _genderGrpButton(double op, String title, IconData icon) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(op)),
          icon: Icon(icon),
          onPressed: () {
            setState(() {
              _gender = title;
            });
          },
          label: Text(title));

  Widget _bloodGrpButton(double op, String title, IconData icon) =>
      ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(op)),
          icon: Icon(icon),
          onPressed: () {
            setState(() {
              _bloodGroup = title;
            });
          },
          label: Text(title));

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return;
    }
    _formKey.currentState!.save();
    // _userEmail = _userEmail.trim();
    // _userFirstName = _userFirstName.trim();
    // _userLastName = _userLastName.trim();
    // _userPassword = _userPassword.trim();
    if (kDebugMode) {
      print('''
    $_authenticationMode 
    ''');
    }
    //
    setState(() {
      _isLoading = true;
    });
    Future.delayed(const Duration(seconds: 3))
        .then((value) => Navigator.pushNamed(context, HomeScreen.routeName));
    // try {
    //   if (_authenticationMode == AuthenticationMode.login) {
    //     await _activateLogin(_userEmail, _userPassword);
    //   } else {
    //     await FirebaseAuthenticationHandler.signup(
    //             context: context,
    //             firstname: _userFirstName,
    //             lastname: _userLastName,
    //             email: _userEmail,
    //             password: _userPassword)
    //         .then((message) => showCustomDialog(context, message));
    //   }
    // } catch (error) {
    //   const errorMessage = 'Failed, check the internet connection later';
    //   return  showCustomDialog(context, errorMessage);
    // } finally {
    //   setState(() {
    //     _authenticationMode = AuthenticationMode.login;
    //     _isLoading = false;
    //   });
    // }
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
                    : 1400,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    AnimatedContainer(
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
                        "images/logo1.PNG",
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
                                .requestFocus(_authenticationMode ==
                                        AuthenticationMode.signup
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
                              AuthenticationMode.signup))
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
                                          .requestFocus(_ageFocusNode),
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
                                    // todo Validate negative age
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _donor.age = value!;
                                  },
                                ),
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
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter Location';
                                    }
                                    // todo Validate negative age
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _donor.location = value!;
                                  },
                                ),
                              ],
                            ),
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
                                .requestFocus(_authenticationMode ==
                                        AuthenticationMode.signup
                                    ? _confirmPasswordFocusNode
                                    : null),
                            textInputAction:
                                _authenticationMode == AuthenticationMode.signup
                                    ? TextInputAction.next
                                    : TextInputAction.done,
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
                          if ((_authenticationMode ==
                              AuthenticationMode.signup))
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
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).requestFocus(null),
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
                              AuthenticationMode.signup))
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
                                            _gender == "Male" ? 1.0 : fadeClr,
                                            "Male",
                                            Icons.male),
                                        _genderGrpButton(
                                            _gender == "Female" ? 1.0 : fadeClr,
                                            "Female",
                                            Icons.female),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if ((_authenticationMode ==
                              AuthenticationMode.signup))
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
                                                _bloodGroup == "O -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "O -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _bloodGroup == "O +"
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
                                                _bloodGroup == "A -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "A -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _bloodGroup == "A +"
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
                                                _bloodGroup == "B -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "B -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _bloodGroup == "B +"
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
                                                _bloodGroup == "AB -"
                                                    ? 1.0
                                                    : fadeClr,
                                                "AB -",
                                                Icons.bloodtype),
                                            _bloodGrpButton(
                                                _bloodGroup == "AB +"
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
                                        AuthenticationMode.login
                                    ? const Text("Login")
                                    : const Text("Register"),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: deviceHeight * 0.05),
                      width: deviceWidth * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _authenticationMode == AuthenticationMode.signup
                                ? "Already have an account?"
                                : "Don\'t have an account?",
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _visible = false;

                                _authenticationMode == AuthenticationMode.login
                                    ? _authenticationMode =
                                        AuthenticationMode.signup
                                    : _authenticationMode =
                                        AuthenticationMode.login;
                              });
                              print(_authenticationMode);
                              Future.delayed(const Duration(milliseconds: 300))
                                  .then((value) => setState(() {}))
                                  .then((value) => setState(() {
                                        _visible = true;
                                        print(_visible);
                                      }));
                            },
                            child: Text(
                              _authenticationMode == AuthenticationMode.login
                                  ? "Register"
                                  : "Login",
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
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
    _genderFocusNode.dispose();
    _bloodTypeFocusNode.dispose();
    _locationFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
  }
}

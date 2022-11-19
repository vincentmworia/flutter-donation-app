import 'package:flutter/material.dart';

import '../helpers/alphabet.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/input_field.dart';

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

  var _userEmail = '';
  var _userFirstName = '';
  var _userLastName = '';
  var _userPassword = '';

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  var _visible = true;

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
                height: deviceHeight,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // if ((_authenticationMode == AuthenticationMode.login))
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin:
                              _authenticationMode == AuthenticationMode.login
                                  ? EdgeInsets.only(
                                      top: deviceHeight * 0.1,
                                      bottom: deviceHeight * 0.1,
                                    )
                                  : EdgeInsets.only(
                                      top: deviceHeight * 0.02,
                                    ),
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth * 0.1),
                          child: Image.asset(
                            "images/logo1.PNG",
                            fit: BoxFit.cover,
                          ),
                          // decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                        ),
                       Visibility(
                         visible:   _visible ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InputField(
                                key: const ValueKey('email'),
                                controller: _emailController,
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
                                        ? _firstNameFocusNode
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
                                  _userEmail = value!;
                                },
                              ),
                              if ((_authenticationMode ==
                                  AuthenticationMode.signup))
                                InputField(
                                  key: const ValueKey('firstName'),
                                  controller: _firstNameController,
                                  hintText: 'First Name',
                                  icon: Icons.person,
                                  obscureText: false,
                                  focusNode: _firstNameFocusNode,
                                  autoCorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).requestFocus(
                                          _authenticationMode ==
                                                  AuthenticationMode.signup
                                              ? _lastNameFocusNode
                                              : _passwordFocusNode),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter First Name';
                                    }
                                    var isCaps = false;
                                    for (String val in alphabet) {
                                      if (val.toUpperCase() == value[0]) {
                                        isCaps = true;
                                        break;
                                      }
                                    }
                                    if (!isCaps) {
                                      return 'Name must start with a capital letter';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userFirstName = value!;
                                  },
                                ),
                              if ((_authenticationMode ==
                                  AuthenticationMode.signup))
                                InputField(
                                  key: const ValueKey('lastName'),
                                  controller: _lastNameController,
                                  hintText: 'Last Name',
                                  icon: Icons.person,
                                  obscureText: false,
                                  focusNode: _lastNameFocusNode,
                                  autoCorrect: false,
                                  enableSuggestions: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context)
                                          .requestFocus(_passwordFocusNode),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 4) {
                                      return 'Enter Last Name';
                                    }
                                    var isCaps = false;
                                    for (String val in alphabet) {
                                      if (val.toUpperCase() == value[0]) {
                                        isCaps = true;
                                        break;
                                      }
                                    }
                                    if (!isCaps) {
                                      return 'Name must start with a capital letter';
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    _userLastName = value!;
                                  },
                                ),
                              InputField(
                                key: const ValueKey('password'),
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
                                textInputAction: _authenticationMode ==
                                        AuthenticationMode.signup
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
                                          _firstNameController.text
                                              .toLowerCase()
                                              .trim() ||
                                      _passwordController.text
                                              .toLowerCase()
                                              .trim() ==
                                          '${_firstNameController.text}${_lastNameController.text}'
                                              .toLowerCase()
                                              .trim() ||
                                      _passwordController.text
                                              .toLowerCase()
                                              .trim() ==
                                          _lastNameController.text
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
                                  _userPassword = value!;
                                },
                              ),
                              if ((_authenticationMode ==
                                  AuthenticationMode.signup))
                                InputField(
                                  key: const ValueKey('confirmPassword'),
                                  controller: _confirmPasswordController,
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
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(150, 65)),
                                  onPressed: () {
                                    print("done");
                                  },
                                  child: _authenticationMode ==
                                          AuthenticationMode.login
                                      ? Text("Login")
                                      : Text("Register")),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: deviceHeight * 0.05),
                          width: deviceWidth * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Don\'t have an account?",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _visible = false;

                                    _authenticationMode ==
                                        AuthenticationMode.login
                                        ? _authenticationMode =
                                        AuthenticationMode.signup
                                        : _authenticationMode =
                                        AuthenticationMode.login;
                                  });
                                  print(_authenticationMode);
                                  Future.delayed(
                                          const Duration(milliseconds: 300))
                                      .then((value) => setState(() {
                                          }))
                                      .then((value) => setState(() {
                                            _visible = true;
                                            print(_visible);
                                          }));
                                },
                                child: Text(
                                  _authenticationMode ==
                                          AuthenticationMode.login
                                      ? "Register"
                                      : "Login",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
}

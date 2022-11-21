import 'package:bloodbankapp/helpers/firebase_auth.dart';
import 'package:bloodbankapp/screens/auth_screen.dart';
import 'package:bloodbankapp/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/logged_in_user.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  var _isLoading = false;

  Widget _buildDrawer({
    required Widget icon,
    required String title,
    required void Function() onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: icon,
          title: Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoggedInUser>(context).user;
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FittedBox(
                      child: Text(
                        (user?.fullName[0].toUpperCase())??"",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ),
              ),
              accountName: Text((user?.fullName)??""),
              accountEmail: Text((user?.email)??""),
            ),
            _buildDrawer(
                icon: const Icon(Icons.logout),
                title: "Logout",
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final returnCode =
                      await FirebaseAuthenticationHandler.logout(context);

                  switch (returnCode) {
                    case ReturnCode.successful:
                      Future.delayed(Duration.zero).then(
                          (value) async => await Navigator.pushReplacementNamed(
                              context, AuthScreen.routeName));
                      break;
                    case ReturnCode.failed:
                      setState(() {
                        _isLoading = false;
                      });
                      Future.delayed(Duration.zero).then((value) async =>
                          await customDialog(context, "Logout Error"));
                      break;
                  }
                }),
          ],
        ),
      ),
    );
  }
}

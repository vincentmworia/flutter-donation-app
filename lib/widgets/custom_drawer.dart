import 'package:bloodbankapp/modules/logged_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/logged_in_user.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoggedInUser>(context, listen: false).user;
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
                        user.fullName[0].toUpperCase(),
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                ),
              ),
              accountName: Text(user.fullName),
              accountEmail: Text(user.email),
            ),
          ],
        ),
      ),
    );
  }
}

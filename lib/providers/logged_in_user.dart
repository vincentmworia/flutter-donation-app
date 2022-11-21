import 'package:flutter/cupertino.dart';

import '../modules/logged_user.dart'  ;

class LoggedInUser with ChangeNotifier {
   LoggedUser? _user;
   LoggedUser? get user => _user;

  void setLoggedUser(LoggedUser? usr) {
    _user = usr;
    notifyListeners();
  }

}

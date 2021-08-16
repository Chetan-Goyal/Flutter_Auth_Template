// TODO: add listen in auth widget builder

import 'package:flutter/material.dart';

enum authState {
  Uninitialised,
  Initialised,
  LoggedIn,
  GoogleSignIn,
  LoggedOut,
}

class AuthHandler extends ChangeNotifier {
  authState value;
  AuthHandler(this.value);

  get getState {
    return value;
  }

  set setAuthState(val) {
    this.value = val;
    notifyListeners();
  }
}

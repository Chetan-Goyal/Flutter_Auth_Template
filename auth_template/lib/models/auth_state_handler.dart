// TODO: add listen in auth widget builder

enum authState { Uninitialised, Initialised, LoggedIn, GoogleSignIn, LoggedOut }

class AuthHandler {
  authState value;
  AuthHandler(this.value);

  get getState {
    return value;
  }

  set setState(val) {
    this.value = val;
  }
}

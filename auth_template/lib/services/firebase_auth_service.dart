import 'package:auth_template/app/add_password/add_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

@immutable
class CurrentUser {
  const CurrentUser({required this.uid});
  final String uid;
}

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  CurrentUser? _userFromFirebase(User? user) {
    print("onAuthStateChanged");
    if (_firebaseAuth.currentUser != null) {
      print(_firebaseAuth.currentUser!.providerData);
    }
    return user == null ? null : CurrentUser(uid: user.uid);
  }

  Stream<CurrentUser?> get onAuthStateChanged {
    return _firebaseAuth.userChanges().map(_userFromFirebase);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<bool> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final authResult = await _firebaseAuth.signInWithCredential(credential);
      _userFromFirebase(authResult.user);

      return true;

      // await _firebaseAuth.createUserWithEmailAndPassword(
      //     email: authResult.user!.email.toString(), password: "password");
      // print("MESSAGE: Google Sign In Completed");

    } catch (error) {
      print("MESSAGE: GOT ERROR IN Google Sign In");
      print(error);
      return false;
    }
  }

  Future<CurrentUser?> signInWithEmail({email, password}) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<CurrentUser?> signUpWithEmail({email, password}) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  Future<bool> addPassword({required password}) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(password);
      print("addPassword Returning True");
      return true;
    } catch (exception) {
      print("Exception $exception");
    }
    return false;
  }

  bool isPassAdded() {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser?.providerData.length == 2) {
      return true;
    }
    return false;
  }
}

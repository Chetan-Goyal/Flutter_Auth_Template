import 'package:auth_template/app/add_password/add_password_page.dart';
import 'package:auth_template/app/sign_up/sign_up_page.dart';
import 'package:auth_template/services/firebase_auth_service.dart';
import 'package:auth_template/services/firebase_storage_service.dart';
import 'package:auth_template/services/firestore_service.dart';
import 'package:auth_template/models/auth_state_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Used to create user-dependant objects that need to be accessible by all widgets.
/// This widget should live above the [MaterialApp].
class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext, AsyncSnapshot<CurrentUser?>) builder;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<FirebaseAuthService>(context, listen: false);
    final authStateHandler = Provider.of<AuthHandler>(context);
    return StreamBuilder<CurrentUser?>(
      stream: authService.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          authStateHandler.value = authState.Initialised;
        }
        final CurrentUser? user = snapshot.data;

        if (authStateHandler.getState == authState.Uninitialised) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (user == null) {
          return MaterialApp(home: SignUpPage());
        } else if (authService.isPassAdded()) {
          return MultiProvider(
            providers: [
              Provider<CurrentUser>.value(value: user),
              Provider<FirestoreService>(
                create: (_) => FirestoreService(uid: user.uid),
              ),
              Provider<FirebaseStorageService>(
                create: (_) => FirebaseStorageService(uid: user.uid),
              ),
            ],
            // Maybe Builder could be needed here for accessing provider in Home
            child: builder(context, snapshot),
          );
        } else {
          return AddPasswordPage(uid: user.uid);
        }
      },
    );
  }
}

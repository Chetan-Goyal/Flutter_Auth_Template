import 'package:auth_template/models/auth_state_handler.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';
import '../../services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

enum Status { Idle, Loading, Failure, Success }

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _AddPasswordPageState createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  TextEditingController _passController = TextEditingController();
  bool _hidePassword = true;

  final _formKey = GlobalKey<FormState>();
  var _status = Status.Idle;

  Future<bool> _linkPassword(BuildContext context) async {
    final authStateHandler = Provider.of<AuthHandler>(context, listen: false);
    // final authStateHandler = context.watch<AuthHandler>();
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    bool result = await auth.addPassword(password: _passController.text);
    if (result) {
      authStateHandler.setAuthState = authState.LoggedIn;
    }
    return result;
    // if (result) {
    //   // Forward to Homepage
    // } else {
    //   // Forward to Error Page
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      hintText: "Password",
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(_hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                    validator: passValidator,
                    obscureText: _hidePassword,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        if (_formKey.currentState?.validate() == true) {
                          // passValidator
                          _linkPassword(context).then((resp) {
                            // print("Loading ")
                            if (resp) {
                              setState(() {
                                print("SUCCESS");
                                _status = Status.Success;
                                // authStateHandler.value = authState.LoggedIn;
                              });
                            } else {
                              setState(() {
                                _status = Status.Failure;
                              });
                              _status = Status.Loading;
                            }
                          });
                        }
                      });
                    },
                    child: Center(child: Text("Submit")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  String? passValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter a Password";
    } else if (password.length < 6) {
      return "Password must consist of 6 or more characters";
    }
    return null;
  }
}

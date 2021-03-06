import 'package:auth_template/models/auth_state_handler.dart';
import 'package:auth_template/services/firebase_auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:auth_template/app/sign_up/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Status { Idle, Loading, Failure, Success }

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _signInFormKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  Status _status = Status.Idle;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> _signInGoogle(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final bool resp = await auth.signInWithGoogle();
    return resp;
  }

  Future<Map> _signInEmail(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      final resp = await auth.signInWithEmail(
          email: emailController.text, password: passwordController.text);
      return {"success": true};
    } catch (e) {
      print(e);
      // TODO: Assigning Correct Error Message (Fail or Google Acc)
      return {"success": false, "message": "unknown"};
    }
  }

  String? emailValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Please Enter an Email Address";
    } else if (EmailValidator.validate(email)) {
      return null;
    }
    return "Please Enter a Valid Email Address";
  }

  String? passValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Please enter a Password";
    } else if (password.length < 6) {
      return "Password must consist of 6 or more characters";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authStateHandler = Provider.of<AuthHandler>(context, listen: false);
    return _status == Status.Loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(title: Text('Sign In')),
            body: Form(
              key: _signInFormKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      hintText: "Email",
                    ),
                    validator: emailValidator,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
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
                        )),
                    validator: passValidator,
                    obscureText: _hidePassword,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_signInFormKey.currentState?.validate() == true) {
                        _status = Status.Loading;
                        _signInEmail(context).then((res) {
                          if (res["success"]) {
                            _status = Status.Success;
                            authStateHandler.value = authState.LoggedIn;
                          } else {
                            // TODO: Message on top of this login page
                            _status = Status.Failure;
                          }
                        });
                      }
                    },
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text("OR"),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _status = Status.Loading;
                      _signInGoogle(context).then((resp) {
                        if (resp) {
                          // successful google sign in
                        } else {
                          // unsuccessful google sign in
                        }
                      });
                    },
                    child: Text(
                      "Continue with Google",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Sign up',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                SignUpPage(),
                                          ));
                                    },
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 18,
                                  ),
                                )
                              ]),
                        ),
                      ))
                ],
              ),
            ),
          );
  }

  void _togglePasswordView() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }
}

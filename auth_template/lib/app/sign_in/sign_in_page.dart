import 'package:auth_template/services/firebase_auth_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:auth_template/app/sign_up/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final _signInFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  Future<void> _signInGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInEmail(BuildContext context) async {
    try {
      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signInWithEmail(
          email: emailController.text, password: passwordController.text);
    } catch (e) {
      print(e);
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
    return Scaffold(
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
              ),
              validator: passValidator,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_signInFormKey.currentState?.validate() == true) {
                  _signInEmail(context);
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
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text("OR"),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _signInGoogle(context),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
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
}

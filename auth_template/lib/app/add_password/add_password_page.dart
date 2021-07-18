// TODO:   Have to add a provider before sign in and sign up handling enum
// TODO:   with registration state and displaying pass page baesd on that

import '../home/home_page.dart';
import '../sign_up/sign_up_page.dart';
import '../../services/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _AddPasswordPageState createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

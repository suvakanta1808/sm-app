import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sm_app/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;
  void _submitFn(String username, String userPassword) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: userPassword,
      );
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('An error occured!'),
          content: Text(error.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: AuthForm(_submitFn, isLoading),
    );
  }
}

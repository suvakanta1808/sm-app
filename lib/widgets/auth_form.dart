import 'package:flutter/material.dart';
import 'package:sm_app/screens/new_user_screen.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this.isLoading);

  final Function(String username, String password) submitForm;
  bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var _username = '';
    var _password = '';

    void _trySubmit() {
      final isValid = _formKey.currentState.validate();

      if (isValid) {
        FocusScope.of(context).unfocus();
        _formKey.currentState.save();
      }

      widget.submitForm(
        _username,
        _password,
      );
    }

    return Center(
      child: Card(
        elevation: 15,
        shadowColor: Theme.of(context).accentColor,
        margin: EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('user-name'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value.length < 4 || value.isEmpty) {
                        return 'Username must be atleast 4 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value.length < 6) {
                        return 'Password must be atleast 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: _trySubmit,
                    child: widget.isLoading
                        ? CircularProgressIndicator()
                        : Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(NewUserScreen.routeName);
                    },
                    child: Text('Create a new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

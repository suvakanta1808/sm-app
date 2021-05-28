import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/post_screens.dart';

class NewUserScreen extends StatefulWidget {
  static const routeName = 'new-user';

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  var _username = '';
  var _email = '';
  var _password = '';
  var _bio = '';
  File _userImage;

  void _createAccount(File image) async {
    final isValid = _formKey.currentState.validate();

    if (!isValid || _userImage == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text('An error occured'),
          title: Text('Please pick an image'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
    _formKey.currentState.save();

    try {
      final _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);

      final ref = FirebaseStorage.instance
          .ref()
          .child('user-images')
          .child(_userCredential.user.uid + '.jpg');

      await ref.putFile(_userImage);

      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredential.user.uid)
          .set({
        'email': _email,
        'username': _username,
        'userImage': url,
        'bio': _bio,
      });
      Navigator.of(context).pushReplacementNamed(PostScreen.routeName);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  void _takeImage() async {
    final _picker = ImagePicker();
    var pickedImageFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _userImage = File(pickedImageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Mention your email id'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Give a user name(Atleast 5 characters long)'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Username must be atleast 5 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Enter password'),
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Password must be atleast 6 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(labelText: 'Add something to your bio'),
                  onSaved: (value) {
                    _bio = value;
                  },
                ),
                SizedBox(
                  height: 26.0,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                      ),
                      child: _userImage == null
                          ? Text(
                              'No Image selected',
                            )
                          : Image(
                              fit: BoxFit.cover,
                              image: FileImage(_userImage),
                            ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _takeImage,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Take a picture'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 76.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RaisedButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () => _createAccount(_userImage),
                      child: Text('Create Account'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

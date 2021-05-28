import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_list.dart';
import '../models/post.dart';
import 'package:sm_app/screens/post_screens.dart';

class NewPostScreen extends StatefulWidget {
  static const routeName = 'new-post';
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  var post = new Post(caption: '', imageUrl: '');

  void _submitPost(File image) async {
    final _isValid = _formKey.currentState.validate();

    if (!_isValid) {
      return;
    }
    _formKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });

      final curUser = FirebaseAuth.instance.currentUser;

      final ref = FirebaseStorage.instance
          .ref()
          .child('post-images')
          .child(curUser.uid + '.jpg');

      await ref.putFile(image);

      final url = await ref.getDownloadURL();
      post = Post(
        caption: post.caption,
        location: post.location,
        imageUrl: url,
      );
      await Provider.of<PostList>(context, listen: false).addNewPost(post);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(PostScreen.routeName);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          content: Text(
            'An unknown errror occured.Please try again later',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(c).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageData =
        ModalRoute.of(context).settings.arguments as Map<String, File>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a new post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(imageData['image']),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Add a caption'),
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a caption(atleast one word)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    post = Post(
                      caption: value,
                      imageUrl: '',
                      location: post.location,
                    );
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Add location(optional)'),
                  onSaved: (value) {
                    post = Post(
                      caption: post.caption,
                      imageUrl: '',
                      location: value,
                    );
                  },
                ),
                RaisedButton(
                  onPressed: () => _submitPost(imageData['image']),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text(
                          'Create post',
                          style: TextStyle(color: Colors.black),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

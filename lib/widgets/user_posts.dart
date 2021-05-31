import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserPosts extends StatefulWidget {
  final String username;

  UserPosts(this.username);
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where(
            'username',
            isEqualTo: widget.username,
          )
          .get(),
      builder: (c, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final posts = dataSnapshot.data.docs;

        return Container(
          width: double.infinity,
          height: 800,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: posts.length,
            itemBuilder: (ctx, i) => Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                posts[i].data()['imageUrl'],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/post.dart';

class PostList with ChangeNotifier {
  var isLoading = false;

  void changeLoadingState() {
    isLoading = !isLoading;
    notifyListeners();
  }

  List<Post> _posts = [
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
    //   Post(
    //     title: 'skm_018',
    //     description: 'A nice place to work in.Stay indoor and stay safe.',
    //     imageUrl: 'https://picsum.photos/200/300.jpg',
    //     likes: 10045,
    //     comments: 1245,
    //   ),
  ];

  List<Post> get posts {
    return [..._posts];
  }

  Future<void> fetchAndLoadPosts() async {
    try {
      final postDocs =
          await FirebaseFirestore.instance.collection('posts').get();
      final _postList = postDocs.docs;
      List<Post> _loadedPosts = [];
      _loadedPosts = _postList
          .map(
            (postData) => Post(
              comments: 1200,
              likes: 100345,
              username: postData.data()['username'],
              caption: postData.data()['postCaption'],
              imageUrl: postData.data()['imageUrl'],
            ),
          )
          .toList();
      _posts = _loadedPosts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addNewPost(Post post) async {
    final curUser = FirebaseAuth.instance.currentUser;

    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(curUser.uid)
        .get();
    final userData = userDocs.data();

    await FirebaseFirestore.instance.collection('posts').add({
      'username': userData['username'],
      'imageUrl': post.imageUrl,
      'postCaption': post.caption,
      'postLoc': post.location,
    });

    final newPost = new Post(
      username: userData['username'],
      imageUrl: post.imageUrl,
      caption: post.caption,
      location: post.location,
    );

    _posts.add(newPost);
    notifyListeners();
  }
}

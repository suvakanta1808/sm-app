import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/story.dart';

class StoryList with ChangeNotifier {
  List<Story> _stories = [];

  List<Story> get stories {
    return [..._stories];
  }

  void addNewStory(Story story) async {
    final curUser = FirebaseAuth.instance.currentUser;

    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(curUser.uid)
        .get();
    final userData = userDocs.data();

    await FirebaseFirestore.instance.collection('story').add({
      'username': userData['username'],
      'imageUrl': story.imageUrl,
    });

    final newStory = new Story(
      imageUrl: story.imageUrl,
      username: userData['username'],
    );

    _stories.add(newStory);
    notifyListeners();
  }

  void fetchAndLoadStories() async {
    final _storyDocs =
        await FirebaseFirestore.instance.collection('story').get();

    final _storyData = _storyDocs.docs;

    List<Story> _loadedStories = [];
    _loadedStories = _storyData
        .map((story) => Story(
              imageUrl: story['imageUrl'],
              username: story['username'],
            ))
        .toList();

    _stories = _loadedStories;
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';

class Post {
  final String username;
  final String caption;
  final String imageUrl;
  final String location;
  final int likes;
  final int comments;

  Post({
    this.username,
    this.location,
    this.comments,
    this.likes,
    @required this.caption,
    @required this.imageUrl,
  });
}

import 'package:flutter/material.dart';

import '../widgets/option_menu.dart';

class PostItem extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;
  final int likes;
  final int comments;

  PostItem({
    this.title,
    this.description,
    this.imageUrl,
    this.likes,
    this.comments,
  });

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  var isFavorite = false;

//  double opacityLevel = 0.0;

  // void _increaseOpacity() {
  //   setState(() {
  //     opacityLevel = opacityLevel == 0.0 ? 1.0 : 0.0;
  //   });
  //   // setState(() {
  //   //   opacityLevel = opacityLevel == 0.0 ? 1.0 : 0.0;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(widget.title),
              ),
              IconButton(
                icon: Icon(Icons.more_vert_outlined),
                onPressed: () {
                  showModalBottomSheet(
                      clipBehavior: Clip.hardEdge,
                      context: context,
                      builder: (c) => OptionMenu());
                },
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
            onDoubleTap: () {
              //  _increaseOpacity();

              setState(() {
                isFavorite = true;
              });
            },
            child:
                //  Stack(
                //   children: [
                Container(
              height: 250,
              width: double.infinity,
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 30,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: isFavorite
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_comment_rounded),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: null,
                ),
                SizedBox(
                  width: 210,
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: null,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.likes} Likes.Liked by rohan_legend and 68 others.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text('     ${widget.title}   ' + '${widget.description}'),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            alignment: Alignment.centerLeft,
            child: Text(
              'View all ${widget.comments} comments..',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            height: 30,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    size: 32,
                  ),
                  onPressed: null,
                ),
                Text(
                  'Add a comment...',
                ),
                SizedBox(
                  width: 100,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.celebration),
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}

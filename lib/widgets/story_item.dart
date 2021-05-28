import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String title;

  StoryItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 83,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.pinkAccent,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundImage:
                  NetworkImage('https://picsum.photos/200/300.jpg'),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          FittedBox(child: Text(title)),
        ],
      ),
    );
  }
}

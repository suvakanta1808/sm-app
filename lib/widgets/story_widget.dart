import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/story_list.dart';
import '../models/story.dart';
import 'story_item.dart';

class StoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<StoryList>(context, listen: false).fetchAndLoadStories();
    final storyData = Provider.of<StoryList>(context).stories;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final _picker = ImagePicker();
              final _pickedImage =
                  await _picker.getImage(source: ImageSource.camera);

              final postImage = File(_pickedImage.path);

              final newStory =
                  new Story(imageUrl: 'https://picsum.photos/200/300.jpg');

              if (_pickedImage != null) {
                Provider.of<StoryList>(context, listen: false)
                    .addNewStory(newStory);
              }
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 83,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person_add_alt_1,
                              size: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FittedBox(child: Text('Your Story')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: storyData.length == 0
                  ? <Widget>[
                      SizedBox(
                        width: 80,
                      ),
                      Text('No Stories yet..')
                    ]
                  : storyData
                      .map((story) => StoryItem(story.username))
                      .toList()),
        ],
      ),
    );
  }
}

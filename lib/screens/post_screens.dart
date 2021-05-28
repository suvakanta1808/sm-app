import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_app/screens/new_post_screen.dart';

import 'package:sm_app/screens/user_profile_screen.dart';

import '../widgets/post_item.dart';
import '../widgets/story_widget.dart';

import '../providers/post_list.dart';

class PostScreen extends StatefulWidget {
  static const routeName = 'post-screen';

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PostList>(context).fetchAndLoadPosts().catchError((error) {
        showDialog(
          context: context,
          builder: (c) => AlertDialog(
            title: Text("An error occured!"),
            content: Text("Something went wrong!"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(c).pop(),
                child: Text('Okay'),
              )
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _refreshPosts() async {
    await Provider.of<PostList>(context, listen: false).fetchAndLoadPosts();
  }

  @override
  Widget build(BuildContext context) {
    var postData = Provider.of<PostList>(context).posts;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.add_box_outlined,
            size: 35,
          ),
          onPressed: () async {
            final _picker = ImagePicker();
            final _pickedImage =
                await _picker.getImage(source: ImageSource.camera);

            final postImage = File(_pickedImage.path);

            if (_pickedImage != null) {
              await Navigator.of(context).pushNamed(NewPostScreen.routeName,
                  arguments: {'image': postImage});
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Instagram',
          style: TextStyle(
            fontSize: 35,
            fontFamily: 'Allura',
            fontWeight: FontWeight.w200,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message_sharp,
              size: 35,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              StoryWidget(),
              SizedBox(
                height: 5,
              ),
              Divider(
                height: 5,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 480,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: postData.length,
                        itemBuilder: (ctx, i) => PostItem(
                          title: postData[i].username,
                          description: postData[i].caption,
                          imageUrl: postData[i].imageUrl,
                          likes: postData[i].likes,
                          comments: postData[i].comments,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          if (i == 4) {
            Navigator.of(context).pushNamed(UserProfileScreen.routeName);
          }
        },
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            // backgroundColor: Colors.black,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.ondemand_video_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_sharp,
            ),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}

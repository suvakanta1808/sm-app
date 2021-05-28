import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = 'user-profile';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var userName = '';
  final curUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Scaffold(
        appBar: AppBar(
          title: Text('username'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                }),
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(curUser.uid)
              .get(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.done) {
              final data = dataSnapshot.data.data();

              userName = data['username'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(data['userImage']),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: <Widget>[
                          Text('490'),
                          Text('Posts'),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      Column(
                        children: <Widget>[
                          Text('1200'),
                          Text('Followers'),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: <Widget>[
                          Text('113'),
                          Text('Following'),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(data['bio']),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton(
                        onPressed: null,
                        child: Text('Edit Profile'),
                      ),
                    ],
                  ),
                  Row(),
                  Row(),
                ],
              );
            } else {
              return Center(
                child: Text('Loading...'),
              );
            }
          },
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.5,
      secondaryActions: [
        Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                title: Text(
                  userName,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.more_time_sharp,
                  size: 33,
                ),
                title: Text('Archive'),
              ),
              ListTile(
                leading: Icon(
                  Icons.access_time_rounded,
                  size: 33,
                ),
                title: Text('Your Activity'),
              ),
              ListTile(
                leading: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 33,
                ),
                title: Text('QR Code'),
              ),
              ListTile(
                leading: Icon(
                  Icons.bookmark_border_sharp,
                  size: 33,
                ),
                title: Text('Saved'),
              ),
              ListTile(
                leading: Icon(
                  Icons.menu_open_sharp,
                  size: 33,
                ),
                title: Text('Close Friends'),
              ),
              ListTile(
                leading: Icon(
                  Icons.person_add_alt,
                  size: 33,
                ),
                title: Text('Discover People'),
              ),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  size: 33,
                ),
                title: Text('Covid-19 Information Center'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

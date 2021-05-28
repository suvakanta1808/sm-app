import 'package:flutter/material.dart';

class OptionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            ListTile(title: Text('Report...')),
            ListTile(title: Text('Turn On Post Notification')),
            ListTile(title: Text('About This Account')),
            ListTile(title: Text('Copy Link')),
            ListTile(title: Text('Share to..')),
            ListTile(title: Text('Unfollow')),
            ListTile(title: Text('Mute')),
          ],
        ),
      ),
    );
  }
}

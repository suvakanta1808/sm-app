import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_app/providers/story_list.dart';
import 'package:sm_app/screens/new_post_screen.dart';
import 'package:sm_app/screens/user_profile_screen.dart';

import './screens/new_user_screen.dart';
import './screens/post_screens.dart';
import './screens/auth_screen.dart';
import './screens/user_profile_screen.dart';
import './screens/splash_screen.dart';

import './providers/post_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PostList(),
        ),
        ChangeNotifierProvider.value(
          value: StoryList(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.pink,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (!streamSnapshot.hasData) {
              return AuthScreen();
            }
            return PostScreen();
          },
        ),
        routes: {
          PostScreen.routeName: (ctx) => PostScreen(),
          NewUserScreen.routeName: (ctx) => NewUserScreen(),
          UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
          NewPostScreen.routeName: (ctx) => NewPostScreen(),
        },
      ),
    );
  }
}

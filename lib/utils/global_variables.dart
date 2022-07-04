

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turismoapp/resources/auth_methods.dart';
import 'package:turismoapp/screens/add_post_screen.dart';
import 'package:turismoapp/screens/feed_screen.dart';
import 'package:turismoapp/screens/search_screen.dart';

import '../providers/user_provider.dart';
import '../screens/profile_screen.dart';

// void logout() async {
//   await AuthMethods().signOut();
// }

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPost(),
  Container(
    height: 600,
    // ignore: unnecessary_const
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        InkWell(
          onTap: () {},
          child: Text("sign out off"),
        )
      ],
    ),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  )
];

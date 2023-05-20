import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Screens/add_post_screen.dart';
import 'package:instagram/Screens/feedScreen.dart';

import '../Screens/ProfileScreen.dart';
import '../Screens/SearchScreen.dart';

const webScreenSize = 600;

final homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  addPostScreen(),
  Center(child: Text('notif')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];

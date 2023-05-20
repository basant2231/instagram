import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Screens/login_screen.dart';

import 'package:instagram/utils/Colors.dart';

import '../cubit/auth_cubit.dart';
import '../widgets/FollowButton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

int? postLength;
int? followers;
int? following;
bool isfollowing = false;

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userdata;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    var postsnap = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    var usersnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    userdata = usersnap.data();
    followers = usersnap.data()?['followers'].length;
    following = usersnap.data()?['following'].length;
    postLength = postsnap.docs.length;
    // isfollowing = usersnap
    //     .data()?['followers']
    //     .contains(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Text(userdata?['username'] ?? ''),
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userdata?['imgurl'] ?? ''),
                            ),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  buildStateColumn(
                                      label: 'posts', num: postLength ?? 9),
                                  buildStateColumn(
                                      label: 'followers', num: followers ?? 0),
                                  buildStateColumn(
                                      label: 'following', num: following ?? 0),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (FirebaseAuth.instance.currentUser?.uid ==
                                    widget.uid)
                                  FollowButton(
                                    function: ()async {
                                      await authCubit.signout();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>LoginScreen() ,));
                                    },
                                    backgroundColor: mobileBackgroundColor,
                                    borderColor: Colors.grey,
                                    text: 'Sign out',
                                    textColor: primaryColor,
                                  )
                                else if (isfollowing)
                                  FollowButton(
                                    function: () async {
                                      await authCubit.followUsers(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userdata!['uid']);
                                           setState(() {
                                        isfollowing = true;
                                        followers = followers! - 1;
                                      });
                                          
                                    },
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.black,
                                    text: 'unfollow',
                                    textColor: primaryColor,
                                  )
                                else if (!isfollowing)
                                  FollowButton(
                                    function: () async {
                                      await authCubit.followUsers(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userdata?['uid']);
                                      setState(() {
                                        isfollowing = true;
                                        followers = followers! + 1;
                                      });
                                    },
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.black,
                                    text: 'Follow',
                                    textColor: primaryColor,
                                  ),
                                
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      'username',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 1),
                      child: Text(userdata?['bio'] ?? '')),
                ],
              ),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1),
                    itemCount: snapshot.data?.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshot.data!.docs[index];
                      return Container(
                        child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(snap['postUrl'])),
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Column buildStateColumn({required int num, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label.toString(),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

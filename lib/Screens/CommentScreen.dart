import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/utils/Colors.dart';

import '../cubit/auth_cubit.dart';
import '../widgets/CommentCard.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.snap});
  final snap;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
 

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final user = BlocProvider.of<AuthCubit>(context);

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: mobileBackgroundColor,
            title: Text('Comments'),
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .orderBy('datePublished',descending: true)
                .snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) =>
               // Container(margin: EdgeInsets.all(20),color: Colors.green,height: 100,width: 50,child: Container(color: Colors.red,),)
                 CommentCard(snap: snapshot.data!.docs[index].data()),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: kToolbarHeight,
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user.info.imgurl),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 8),
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Comment as ${user.info.username}',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await user.sendcommentstofirestore(
                        postId: widget.snap['postId'],
                        text: commentController.text,
                        uid: user.info.uid,
                        name: user.info.username,
                        profilepic: user.info.imgurl,
                      );
                      commentController.text = '';
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Text(
                        'Post',
                        style: TextStyle(color: blueColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

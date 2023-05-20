import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/utils/Colors.dart';
import 'package:intl/intl.dart';

import '../Screens/CommentScreen.dart';
import '../cubit/auth_cubit.dart';
import 'like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);

  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
   Future<QuerySnapshot>? snapp;
   int? commentsnum;

  @override
  void initState() {
    super.initState();
    snapp = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    snapp?.then((snapshot) {
      setState(() {
        commentsnum = snapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          color: mobileBackgroundColor,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            //header section
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                    .copyWith(right: 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.snap['profImage']),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                      child: ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    children: [
                                      'Delete',
                                    ]
                                        .map((e) => InkWell(
                                              onTap: () {
                                                user.deletePost(postId:widget.snap['postId']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList(),
                                  )));
                        },
                        icon: Icon(Icons.more_vert))
                  ],
                ),
                //img section
              ),
              GestureDetector(
                onDoubleTap: () async {
                  await user.likePost(
                      postId: widget.snap['postId'],
                      uid: user.info.uid,
                      likes: widget.snap['likes']);
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['postUrl'],
                        fit: BoxFit.fill,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 100,
                        ),
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  LikeAnimation(
                    isAnimating: widget.snap['likes'].contains(user.info.uid),
                    smallLike: true,
                    child: IconButton(
                        icon: widget.snap['likes'].contains(user.info.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                        onPressed: ()async {
                         
                         await  user.likePost(
                                postId: widget.snap['postId'],
                                uid: user.info.uid,
                                likes: widget.snap['likes']);
                            setState(() {
                              isLikeAnimating = true;
                            });
                         
                        }),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentScreen(snap: widget.snap,),
                            ));
                      },
                      icon: Icon(Icons.comment_outlined)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                  ))
                ],
              ),
              //description and number of comments
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w700),
                          child: Text('${widget.snap['likes'].length} likes',
                              style: Theme.of(context).textTheme.bodyMedium)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 8),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(color: primaryColor),
                                children: [
                              TextSpan(
                                  text: widget.snap['username'],
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: '    ${widget.snap['description']}',
                              ),
                            ])),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      'View all ${commentsnum} comments',
                      style: TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(widget.snap['datePublished'])),
                    style: TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


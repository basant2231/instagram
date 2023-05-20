import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../model/userr.dart';
import '../utils/Colors.dart';

class addPostScreen extends StatefulWidget {
  const addPostScreen({super.key});
  @override
  State<addPostScreen> createState() => _addPostScreenState();
}

User? user;
final descriptionController = TextEditingController();

class _addPostScreenState extends State<addPostScreen> {
  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is PostedSuccessfullyState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post uploaded successfully!'),
            ),
          );
        } else if (state is PostedFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload post.'),
            ),
          );
        }
      },
      builder: (context, state) {
        return authCubit.userImgFile == null
            ? Center(
                child: IconButton(
                  onPressed: () {
                    authCubit.selectImageInstagram(context);
                  },
                  icon: Icon(Icons.upload),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  actions: [
                    TextButton(
                        onPressed: () {
                          authCubit.postImage(
                              uid: authCubit.info.uid,
                              username: authCubit.info.username,
                              profImage: authCubit.info.imgurl);
                        },
                        child: Text(
                          'Post',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ))
                  ],
                  backgroundColor: mobileBackgroundColor,
                  title: Text('Post to'),
                  leading: IconButton(
                      onPressed: () {
                        authCubit.clearimg();
                      }, icon: Icon(Icons.arrow_back)),
                ),
                body: Column(
                  children: [
                    State is PostedLoadingState
                        ? LinearProgressIndicator()
                        : Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Divider(),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        authCubit.userImgFile != null
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(authCubit.info.imgurl))
                            : CircleAvatar(
                                radius: 64,
                                child: Icon(Icons.person, size: 64),
                              ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextField(
                            controller: descriptionController,
                            maxLength: 8,
                            decoration: InputDecoration(
                                hintText: 'write a caption',
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                    image: MemoryImage(
                                        authCubit.userImgFileBytes!)),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    )
                  ],
                ),
              );
      },
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/model/comment.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/add_post_screen.dart';
import '../model/post.dart';
import '../model/userr.dart' as model;
import '../Constants/constants.dart';
import 'package:uuid/uuid.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var imgurl;
  Future<String?> signupuser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required File? file,
  }) async {
    emit(SignupLoadingState());
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print('dhajdhajdhj ${cred.user!.uid}');
        //save the rest of data to the firestore database
        imgurl = await uploadImageToStorage(
            childname: 'profilepicture/${basename(userImgFile!.path)}',
            file: userImgFile!,
            isPost: false);
        model.User user = model.User(
          //when there is two the same name make a difference
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          imgurl: imgurl,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        debugPrint('img url is $imgurl');

        print(cred.user!.uid);
        emit(SignupSuccesState());
        return cred.user!.uid;
      }
    } on FirebaseException catch (e) {
      print(e);

      emit(SignupFailedState(message: e.toString()));
    } catch (e) {
      print(e);
      emit(SignupFailedState(message: e.toString()));
    }

    return null;
  }

  File? userImgFile;

  /// Uploads an image file to Firebase Storage and returns the download URL.
  ///
  /// Parameters:
  ///   - childname: The name of the child folder in Firebase Storage where the image will be uploaded.
  ///   - file: The image file to be uploaded.
  ///   - isPost: A boolean flag that indicates whether the image is being uploaded as part of a post (true) or as a user's profile image (false).
  ///
  /// Returns:
  ///   The download URL of the uploaded image as a string.
  Future<String> uploadImageToStorage({
    required String childname,
    required File file,
    required bool isPost,
  }) async {
    // Create a reference to the Firebase Storage location where the image will be uploaded.
    // The child folder is specified by the `childname` parameter, and the user ID is used as the filename.
    Reference imageref =
        FirebaseStorage.instance.ref().child(childname).child(info.uid);

    // If the image is being uploaded as part of a post, create a unique ID for the image and add it to the filename.
    if (isPost) {
      String id = Uuid().v1();
      imageref = imageref.child(id);
    }

    // Print the reference to the console for debugging purposes.
    print(imageref);

    // Read the bytes of the image file.
    Uint8List bytes = file.readAsBytesSync();

    // Upload the image to Firebase Storage using a `UploadTask`.
    UploadTask uploadTask = imageref.putData(bytes);
    TaskSnapshot snap = await uploadTask;

    // Get the download URL of the uploaded image.
    String downloadUrl = await snap.ref.getDownloadURL();

    // Return the download URL as a string.
    return downloadUrl;
  }

  /******************************************************************* */

  login({required String email, required String password}) async {
    try {
      emit(LoginLoadingState());
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        final sharedpref = await SharedPreferences.getInstance();
        await sharedpref.setString("User ID", userCredential.user!.uid);
        Constants.UserId = sharedpref.getString("User ID");
        emit(LoginSuccessState());
      }
    } catch (e) {
      print(e);
      emit(LoginFailedState(message: e.toString()));
    }
  }
  /******************************************************************* */

  void getUsername() async {
    emit(userinfoLoadedState());
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      info = await model.User.fromSnap(snap: snap);
      emit(userinfoSuccessState());
    } catch (e) {
      emit(userinfoFailedState(message: e.toString()));
    }
  }

  var info;
  /******************************************************************* */
  late int page;
  late PageController pagecontroller;
  var bottomnavindex = 0;

  void initializePageController() {
    pagecontroller = PageController(initialPage: bottomnavindex);
  }

/******************************************************************* */
  void changebottomnavindex({required int index}) {
    bottomnavindex = index;
    emit(ChangeBottomNavIndexState());
  }

  void navigationTapped({required int page}) {
    pagecontroller.jumpToPage(page);
  }

/******************************************************************* */
  selectImageInstagram(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await pickImage(ImageSource.camera);
                if (file != null) {
                  userImgFile = file;
                  _loadUserImgFileBytes();
                  emit(CameraSelectedSuccess());
                }
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                final file = await pickImage(ImageSource.gallery);
                if (file != null) {
                  userImgFile = file;
                  _loadUserImgFileBytes();
                  emit(GallerySelectedSuccess());
                }
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                emit(CancelSuccess());
              },
            ),
          ],
        );
      },
    );
  }

/******************************************************************* */
  Future<File?> pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) {
      emit(UserImagePickedFailedState());
      return null;
    } else {
      final imageFile = File(pickedImage.path);
      emit(UserImagePickedSuccessState());
      return imageFile;
    }
  }

/******************************************************************* */
  Uint8List? userImgFileBytes;

  void _loadUserImgFileBytes() {
    if (userImgFile != null) {
      userImgFileBytes = userImgFile!.readAsBytesSync();
    }
  }

/******************************************************************* */
  void postImage(
      {required String uid,
      required String username,
      required String profImage}) async {
    // try {
    emit(PostedLoadingState());
    await uploadPostToFirestore(
        description: descriptionController.text,
        uid: username,
        file: userImgFile!,
        username: username,
        profImage: profImage);
    // descriptionController.text, userImgFile!, uid, username, profImage

    emit(PostedSuccessfullyState(message: 'posted succesfully'));
    // } catch (e) {
    emit(PostedFailedState(message: 'njnjnj'));
    //   print(e);
    // }
  }

/******************************************************************* */
  Future<String?> uploadPostToFirestore(
      {required String description,
      required File file,
      required String uid,
      required String username,
      required String profImage}) async {
    // try {
    emit(uploadPostsFirestoreLoading());

    print('saasasasa');
    // Upload the image to Cloud Storage
    String photoUrl = await uploadImageToStorage(
        childname: 'posts', file: userImgFile!, isPost: true);

    // Generate a new post ID using the UUID library
    String postId = Uuid().v1();

    // Create a new Post object
    print('nononononononononononon');
    Post post = await Post(
      uid: uid,
      username: username,
      postId: postId,
      datePublished: DateTime.now(),
      postUrl: photoUrl,
      profImage: profImage,
      description: description,
      likes: [],
    );

    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
    // Add the post to Firestore
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .set(post.toJson());
    print('yarrrrrrrrrrrrrrrrrrrab');
    clearimg();
    emit(uploadPostsFirestoreSuccess());

    // Return the post ID as a string
    return postId;
    // } catch (e) {
    //   print('error uploading post to firestore');
    //   emit(uploadPostsFirestoreFailed(message: e.toString()));
    //   print(e);
    // }
    // return null;
  }

/******************************************************************* */
  void clearimg() {
    userImgFile = null;
    emit(clearimgState());
  }

/*********************************************************************** */
  Future<void> likePost(
      {required String postId,
      required String uid,
      required List likes}) async {
    try {
      if (likes.contains(uid)) {
        //if the like exist remove it
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        //if the like doesnot exist add it
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
        emit(LikePostSuccesState());
      }
    } catch (e) {
      emit(LikePostFailedState());
      print(e.toString());
    }
  }

/*********************************************************************** */
 var commentsnum;
 Future<void> sendcommentstofirestore(
      {required String postId,
      required String text,
      required String uid,
      required String name,
      required String profilepic}) async {
    try {
      emit(SendCommentsToFirestoreLoading());
      String commentid = Uuid().v1();
      if (text.isNotEmpty) {
        print('we will see');
        Commentt comment = Commentt(
            name: name,
            uid: uid,
            text: text,
            commentId: commentid,
            datePublished: DateTime.now());
        var res = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentid)
            .set(comment.toJson());
            print('commmmments');
           

      }else{
        print('text is empty');
      }
      emit(SendCommentsToFirestoreSuccess());
    } catch (e) {
      emit(SendCommentsToFirestoreFailedd());
      print(e);
    }
  }
  Future<void>deletePost({required String postId})async{
    try {
   await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId).delete();
            emit(DeleteSuccessToFirestore());
    } catch (e) {
      print(e); 
      emit(DeleteFailedToFirestore());
    }
  }
  Future<void>followUsers(String uid,String followId)async{
try {
  //i am getting the data so i can check if i am following or not
  DocumentSnapshot snap=await _firestore.collection('users').doc(uid).get();
List following=(snap.data()! as dynamic)['following'];
if(following.contains(followId)){
  //remove the followers from the following id and following
  await _firestore.collection('users').doc(followId).update({
    'followers':FieldValue.arrayRemove([uid]),
  });
  await _firestore.collection('users').doc(uid).update({
    'following':FieldValue.arrayRemove([followId]),
  });
}else{
  await _firestore.collection('users').doc(followId).update({
    'followers':FieldValue.arrayUnion([uid]),
  });
  await _firestore.collection('users').doc(uid).update({
    'following':FieldValue.arrayUnion([followId]),
  });

}
} catch (e) {
  print(e); 
}
  }
  Future<void>signout()async{
    await _auth.signOut();
  }
}

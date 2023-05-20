import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String uid;
  String email;
  String bio;
  List followers;
  List following;
  String imgurl;

  User({
    required this.username,
    required this.uid,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.imgurl,
  });

  factory User.fromJson({required Map<String, dynamic> json}) {
    return User(
      username: json['username'] as String,
      uid: json['uid'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      followers: List<String>.from(json['followers'] as List<dynamic>),
      following: List<String>.from(json['following'] as List<dynamic>),
      imgurl: json['imgurl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'email': email,
      'bio': bio,
      'followers': followers,
      'following': following,
      'imgurl': imgurl,
    };
  }

  static User fromSnap({required DocumentSnapshot snap}) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'] as String,
      uid: snapshot['uid'] as String,
      bio: snapshot['bio'] as String,
      email: snapshot['email'] as String,
      imgurl: snapshot['imgurl'] as String,
      followers: List<String>.from(snapshot['followers'] as List<dynamic>),
      following: List<String>.from(snapshot['following'] as List<dynamic>),
    );
  }
}

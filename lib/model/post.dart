import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  var likes;
  final String description;

  Post({
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    this.likes=false,
    required this.description,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      uid: json['uid'],
      username: json['username'],
      postId: json['postId'],
      datePublished: DateTime.parse(json['datePublished']),
      postUrl: json['postUrl'],
      profImage: json['profImage'],
      likes: json['likes'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'postId': postId,
      'datePublished': datePublished.toIso8601String(),
      'postUrl': postUrl,
      'profImage': profImage,
      'likes': likes,
      'description': description,
    };
  }
  static Post fromSnap({required DocumentSnapshot snap}) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: DateTime.parse(snapshot['datePublished']),
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
      description: snapshot['description'],
    );
  }
}

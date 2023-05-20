

import 'dart:convert';

class Commentt {
  final String name;
  final String uid;
  final String text;
  final String commentId;
  final DateTime datePublished;

  Commentt({
    required this.name,
    required this.uid,
    required this.text,
    required this.commentId,
    required this.datePublished,
  });

  factory Commentt.fromJson({required Map<String, dynamic> json}) {
    return Commentt(
      name: json['name'],
      uid: json['uid'],
      text: json['text'],
      commentId: json['commentId'],
      datePublished: DateTime.parse(json['datePublished']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'text': text,
      'commentId': commentId,
      'datePublished': datePublished.toIso8601String(),
    };
  }
}

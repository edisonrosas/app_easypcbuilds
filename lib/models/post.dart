import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final double latitud;
  final double longitud;
  String ubicationTitle ;
  String ubicationSnippet ;

   Post(

      {required this.description,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.latitud,
        required this.longitud,
        this.ubicationTitle = "",
        this.ubicationSnippet = "",
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(

      description: snapshot["description"],
      uid: snapshot["uid"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot['postUrl'],
      profImage: snapshot['profImage'],
      latitud: double.parse(snapshot['latitud']),
      longitud: double.parse(snapshot['longitud']),

    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'latitud' : latitud.toString(),
        'longitud' : longitud.toString(),
        'ubicationTitle' : ubicationTitle,
        'ubicationSnippet' : ubicationSnippet
      };
}
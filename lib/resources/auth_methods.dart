import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:turismoapp/models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:turismoapp/resources/storage_methods.dart';

import '../providers/user_provider.dart';

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<UserProvider>(context, listen: false),
      //...other disposable providers
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }
  List<String> setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error ocurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file,false);

        model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            caseSearch: setSearchParam(username));

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });
        res = 'succes';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = "the email isn't formated";
      } else if (err.code == 'weak-password') {
        res = 'password should be at least 6 characters';
      }
      res = err.toString();
    }
    print(res);
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error ocurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'succes';
      } else {
        res = 'please enter all the fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = 'Usuario no encontrado, intenta otra vez';
      } else {
        res = err.toString();
      }
    }
    return res;
  }
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

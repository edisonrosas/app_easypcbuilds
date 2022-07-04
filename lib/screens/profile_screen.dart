import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turismoapp/models/user.dart' as model;
import 'package:turismoapp/providers/user_provider.dart';
import 'package:turismoapp/resources/firestore_methods.dart';
import 'package:turismoapp/utils/colors.dart';
import 'package:turismoapp/widgets/follow_button.dart';
import 'package:provider/provider.dart';

import '../resources/auth_methods.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int postsLen = 0;
  var userData = {};
  bool isLoading = false;
  int followers = 0;

  @override
  void initState() {
    super.initState();
    getPostsLen();
  }

  getPostsLen() async {
    setState(() {
      isLoading = true;
    });
    var snap = await FirebaseFirestore.instance
        .collection("posts")
        .where('uid', isEqualTo: widget.uid)
        .get();
    var userSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();
    postsLen = snap.docs.length;
    userData = userSnap.data()!;
    isFollowing =
        userSnap['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
    followers = userSnap['followers'].length;
    setState(() {
      isLoading = false;
    });
  }
  void clearData(){

      isFollowing = false;
      postsLen = 0;
      userData = {};
      isLoading = false;
      followers = 0;

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getPostsLen();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final UserProvider usuario = Provider.of<UserProvider>(context,listen: false);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: <Widget>[
                // Profile Picture, Stats column, Follow, Unfollow Button, username and bio
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData["photoUrl"]),
                          ),
                          // stats
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    buildStatColumn("posts", postsLen),
                                    buildStatColumn(
                                      "followers",
                                      followers,
                                    ),
                                    buildStatColumn(
                                      "following",
                                      userData['following'].length,
                                    ),
                                  ],
                                ),
                                // buttons -> edit profile, follow, unfollow
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      user.uid == widget.uid
                                          ? FollowButton(
                                              text: "Sign Out",
                                              backgroundColor:
                                                  mobileBackgroundColor,
                                              textColor: primaryColor,
                                              borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              clearData();
                                              print("hola");
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                const LoginScreen(),
                                              );
                                            },
                                            )
                                          : isFollowing
                                              ? FollowButton(
                                                  text: "Unfollow",
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    await FireStoreMethods()
                                                        .followUser(user.uid,
                                                            userData['uid']);
                                                    setState(() {
                                                      isFollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                )
                                              : FollowButton(
                                                  text: "Follow",
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  borderColor: Colors.blue,
                                                  function: () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                      user.uid,
                                                      userData['uid'],
                                                    );
                                                    setState(() {
                                                      isFollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                ),
                                    ]),
                              ],
                            ),
                          )
                        ],
                      ),
                      // usernmae and description
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            userData['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(userData['bio']),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // displaying user posts
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (BuildContext coontext, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot video =
                            (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(
                              (video.data()! as dynamic)["postUrl"],
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(String label, int number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4.0),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ))
      ],
    );
  }
}
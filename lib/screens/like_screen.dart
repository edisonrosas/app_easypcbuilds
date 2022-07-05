import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
// import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import 'profile_screen.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {

  final TextEditingController searchController = TextEditingController();
  bool nolikes = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text("Likes")
        ),
        body: nolikes
            ? Text("NO has dado like a ninguna publicacion")
            : FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .where("likes",arrayContains: user.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => ClipRRect(
                // borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover),
              ),
              staggeredTileBuilder: (index) => StaggeredTile.count(
                  (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            );
          },
        ));
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turismoapp/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:turismoapp/widgets/ShowUbication.dart';
import 'package:turismoapp/widgets/like_animation.dart';
import 'package:turismoapp/models/user.dart' as model;

import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/comment_screen.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);


  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;
  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  fetchComments() async {
    commentLen = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .snapshots()
        .length;
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
        true
      );
    }

    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        err.toString(),
        context,
        true
      );
    }
  }
  void showUbication() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          if (widget.snap["ubicationTitle"] == ""){
            return ShowUbication(latitud: widget.snap['latitud'], longitud: widget.snap['longitud']);
          }else {
            return ShowUbication(latitud: widget.snap['latitud'], longitud: widget.snap['longitud'],title: widget.snap["ubicationTitle"] ,snippet: widget.snap["ubicationSnippet"],);
          }

        });
  }
  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Column(
      children: [
        // HEADER SECTION OF THE POST
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 16,
          ).copyWith(right: 0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap["profImage"]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.snap["username"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                    onTap: () {
                                      // delete the post
                                      deletePost(
                                                widget.snap['postId']
                                                    .toString(),
                                              );
                                      // remove the dialog box
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                )
                                .toList()),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert),
              )
            ],
          ),
        ),
        // IMAGE SECTION OF THE POST
        GestureDetector(
          onDoubleTap: () {
             FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap["postUrl"],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                opacity: isLikeAnimating? 1 : 0,
                duration: const Duration(
                  milliseconds: 200,
                ),
                child: LikeAnimation(
                  child: const Icon(Icons.favorite, color: Colors.white,size : 100),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(milliseconds: 400),
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
        // LIKE, COMMENT SECTION OF THE POST
        Row(
          children: <Widget>[
            LikeAnimation(
              isAnimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                  onPressed: () => FireStoreMethods().likePost(
                    widget.snap['postId'].toString(),
                    user.uid,
                    widget.snap['likes'],
                  ),
                  ),
            ),
            IconButton(
                icon: const Icon(
                  Icons.comment_outlined,
                ),
                onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                    postId: widget.snap['postId'].toString(),
                  ),
                ),
                ),
            ),
            IconButton(
                icon: const Icon(
                  Icons.send,
                ),
                onPressed: () {}),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  icon: const Icon(Icons.location_on_outlined ),
                  onPressed: showUbication,

              ),

            ))
          ],
        ),
        //DESCRIPTION
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.snap["username"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                child: Container(
                  child: Text(
                    'View all $commentLen comments',
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.snap['postId'].toString(),
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(
                    color: secondaryColor,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ],
          ),
        )
      ],
    );
  }
}

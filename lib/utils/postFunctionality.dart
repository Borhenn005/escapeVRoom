import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostFunctionality with ChangeNotifier {
  TextEditingController commentController = TextEditingController();

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('Likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserName,
      'userId': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'username': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserName,
      'userId': Provider.of<Authentication>(context, listen: false).getUserId,
      'userimage': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperation>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now(),
    });
  }

  showCommentSheet(BuildContext context, String docId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(
                    thickness: 3,
                    color: whiteColor,
                  ),
                ),
                Container(
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: whiteColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        color: blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.11,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          child: CircleAvatar(
                                            backgroundColor: darkColor,
                                            radius: 15.0,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot['userimage']),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    documentSnapshot[
                                                        'username'],
                                                    style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color: blueColor,
                                                ),
                                              ),
                                              Text(
                                                '0',
                                                style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  FontAwesomeIcons.reply,
                                                  color: yellowColor,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  FontAwesomeIcons.trashCan,
                                                  color: redColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: blueColor,
                                              size: 12,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              documentSnapshot['comment'],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: darkColor.withOpacity(0.2),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextField(
                          controller: commentController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Add Comment...",
                            hintStyle: TextStyle(
                              color: whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          print('Adding Comment ! ');
                        },
                        backgroundColor: greenColor,
                        child: Icon(
                          FontAwesomeIcons.comment,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Divider(
                      thickness: 3,
                      color: whiteColor,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: 110,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Likes",
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('Likes')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView(
                              children: snapshot.data!.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return ListTile(
                                  leading: GestureDetector(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['userimage']),
                                    ),
                                  ),
                                  title: Text(
                                    documentSnapshot['username'],
                                    style: TextStyle(
                                      color: blueColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    documentSnapshot['useremail'],
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId !=
                                          documentSnapshot['userId']
                                      ? MaterialButton(
                                          color: blueColor,
                                          child: Text(
                                            'Follow',
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {},
                                        )
                                      : const SizedBox(
                                          width: 0.0,
                                          height: 0.0,
                                        ),
                                );
                              }).toList(),
                            );
                          }
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

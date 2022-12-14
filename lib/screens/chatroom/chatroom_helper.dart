import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/screens/messaging/group_messaging/group_message.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:escaperoom/utils/post_functionality.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/appcolors.dart';
import '../altProfile/alt_profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomHelper with ChangeNotifier {
  TextEditingController chatRoomController = TextEditingController();

  String chatRoomAvatarUrl = "";
  String chatRoomId = "";

  String get getChatRoomAvatarUrl => chatRoomAvatarUrl;
  String get getChatRoomId => chatRoomId;

  String latestMessageTime = '';
  String get getLatestMessageTime => latestMessageTime;

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: blueGreyColor.withOpacity(0.4),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: 'Chat',
          style: TextStyle(
            color: whiteColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: 'Box',
              style: TextStyle(
                color: blueColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: whiteColor,
          ),
          onPressed: () {},
        ),
      ],
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          EvaIcons.plus,
          color: greenColor,
          size: 28,
        ),
      ),
    );
  }

  showCreateChatRoomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.27,
              decoration: BoxDecoration(
                color: blueGreyColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
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
                  Text(
                    'Select ChatRoom Avatar ',
                    style: TextStyle(
                      color: greenColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatAvatars')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return GestureDetector(
                                onTap: () {
                                  chatRoomAvatarUrl = documentSnapshot['uri'];
                                  notifyListeners();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  height: 40,
                                  width: 52,
                                  decoration: BoxDecoration(
                                    border: chatRoomAvatarUrl ==
                                            documentSnapshot['uri']
                                        ? Border.all(
                                            color: greenColor,
                                          )
                                        : null,
                                  ),
                                  child: Image.network(documentSnapshot['uri']),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: chatRoomController,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter ChatRoom name',
                            hintStyle: TextStyle(
                              color: whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .submitChatRoomData(
                            chatRoomController.text,
                            {
                              'roomavatar': getChatRoomAvatarUrl,
                              'time': Timestamp.now(),
                              'roomname': chatRoomController.text,
                              'username': Provider.of<FirebaseOperation>(
                                context,
                                listen: false,
                              ).getInitUserName,
                              'useremail': Provider.of<FirebaseOperation>(
                                context,
                                listen: false,
                              ).getInitUserEmail,
                              'userimage': Provider.of<FirebaseOperation>(
                                context,
                                listen: false,
                              ).getInitUserImage,
                              'useruid': Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserId,
                              'lastmessage': '',
                              'lastmessagetime': Timestamp.now(),
                            },
                          ).whenComplete(() async {
                            FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(chatRoomController.text)
                                .collection('members')
                                .doc(Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId)
                                .set({
                              'joined': true,
                              'username': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'useremail': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'userimage': Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                              'time': Timestamp.now()
                            });
                            Navigator.pop(context);
                            chatRoomController.clear();
                          });
                        },
                        backgroundColor: greenColor.withOpacity(0.8),
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  fetchChatRooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .orderBy('lastmessagetime',descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: blueGreyColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                child: ListTile(
                  onLongPress: () {
                    showChatRoomDetails(context, documentSnapshot);
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupMessage(
                          chatDocuemnt: documentSnapshot,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(documentSnapshot['roomavatar']),
                  ),
                  title: Text(
                    documentSnapshot['roomname'],
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return AnimatedDefaultTextStyle(
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: const Text('...'),
                          );
                        } else if (!snapshot.hasData) {
                          return const SizedBox(width: 0.0, height: 0.0);
                        } else if ((snapshot.data!.docs.first['username'] !=
                                null) &
                            (snapshot.data!.docs.first['message'] != '')) {
                          return Text(
                            '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else if ((snapshot.data!.docs.first['username'] !=
                                null) &
                            (snapshot.data!.docs.first['sticker'] != '')) {
                          return Text(
                            '${snapshot.data!.docs.first['username']} : Sticker',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          return const SizedBox(width: 0.0, height: 0.0);
                        }
                      } catch (e) {
                        return SizedBox(
                          child: Text(
                            'No Message yet !',
                            style: TextStyle(
                              color: blueColor,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  trailing: Text(
                    Provider.of<PostFunctionality>(context, listen: false)
                        .showTimeAgo(
                      documentSnapshot['lastmessagetime'],
                    ),
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  showChatRoomDetails(BuildContext context, DocumentSnapshot chatDocument) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height:
                Provider.of<Authentication>(context, listen: false).getUserId ==
                        chatDocument['useruid']
                    ? MediaQuery.of(context).size.height * 0.45
                    : MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              color: blueGreyColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
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
                      color: blueColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      "Members",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(chatDocument.id)
                        .collection('members')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId !=
                                    documentSnapshot['useruid']) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AltProfile(
                                        userID: documentSnapshot['useruid'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: darkColor,
                                      backgroundImage: NetworkImage(
                                          documentSnapshot['userimage']),
                                    ),
                                    Text(
                                      documentSnapshot['username'],
                                      style: TextStyle(
                                        color: whiteColor,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  width: 110,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: yellowColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      "Admin",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(chatDocument['userimage']),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        chatDocument['username'],
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserId ==
                              chatDocument['useruid']
                          ? MaterialButton(
                              color: redColor,
                              child: Text(
                                'Delete ChatRoom',
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () {
                                showAlertDialogDeleteChatroom(
                                    context, chatDocument);
                              },
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }

  showAlertDialogDeleteChatroom(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: darkColor,
            title: Text(
              'Delete ${documentSnapshot['roomname']}? ',
              style: TextStyle(
                color: whiteColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: whiteColor,
                  ),
                ),
              ),
              MaterialButton(
                color: redColor,
                onPressed: () {
                  Provider.of<FirebaseOperation>(context, listen: false)
                      .deleteChatRoom(documentSnapshot.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

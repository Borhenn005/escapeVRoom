import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../altProfile/alt_profile.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String username = '';
  bool? isFollow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueGreyColor.withOpacity(0.4),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: 'Find',
            style: TextStyle(
              color: whiteColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Friends',
                style: TextStyle(
                  color: lightBlueColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 12),
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: blueGreyColor.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(
                        color: whiteColor,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                      borderSide: BorderSide(
                        color: whiteColor,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: whiteColor,
                    ),
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      color: whiteColor,
                      fontSize: 14.0,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      username = val;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: blueGreyColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        if (username.isEmpty) {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot['userId'] !=
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    bottom: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: whiteColor.withOpacity(0.9),
                                  ),
                                  child: ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AltProfile(
                                              userID:
                                                  documentSnapshot['userId'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          documentSnapshot['userimage'],
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      documentSnapshot['username'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot['useremail'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    trailing: MaterialButton(
                                      color: blueColor,
                                      onPressed: () {},
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox(
                                  width: 0,
                                  height: 0,
                                );
                              }
                            }).toList(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot['username']
                                      .toString()
                                      .toLowerCase()
                                      .contains(username.toLowerCase()) &&
                                  (Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserId !=
                                      documentSnapshot['userId'])) {
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                    bottom: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: whiteColor.withOpacity(0.9),
                                  ),
                                  child: ListTile(
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AltProfile(
                                              userID:
                                                  documentSnapshot['userId'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          documentSnapshot['userimage'],
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      documentSnapshot['username'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Text(
                                      documentSnapshot['useremail'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    trailing: MaterialButton(
                                      color: blueColor,
                                      onPressed: () {},
                                      child: Text(
                                        'Follow',
                                        style: TextStyle(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox(
                                  width: 0,
                                  height: 0,
                                );
                              }
                            }).toList(),
                          );
                        }
                      } else {
                        return const SizedBox(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkIfDocExists(String userConnected, String followingId) async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userConnected)
        .collection('following')
        .doc(followingId)
        .get();

    return doc.exists; 

    // print('output value : $output');

    // var collectionRef = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userConnected)
    //     .collection('following');

    // var doc = await collectionRef.doc(followingId).get();
    // if (doc.exists) {
    //   return 'y';
    // } else {
    //   return 'n';
    // }
  }
}

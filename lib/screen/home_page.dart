import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/screen/auth/login_screen.dart';
import 'package:wechat_app/screen/profile_screen.dart';
import 'package:wechat_app/widgets/chat_user_card.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    FirebaseHelper.getSelfInfo();
    FirebaseHelper.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message){

      log("Message: $message");
      if(FirebaseHelper.auth.currentUser != null){
        if(message.toString().contains('resume')) FirebaseHelper.updateActiveStatus(true);
        if(message.toString().contains('pause')) FirebaseHelper.updateActiveStatus(false);
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search (Name, Email, ...)"),
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                    onChanged: (val) {
                      //   Search logic
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name!.toLowerCase().contains(val.toLowerCase()) ||
                            i.email!
                                .toLowerCase()
                                .contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text("We Chat"),
            actions: [
              // TODO: ADD SEARCH FUNCTION
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            user: FirebaseHelper.me,
                          ),
                        ));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),

          // TODO: ADD NEW USER
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              },
              child: const Icon(CupertinoIcons.chat_bubble_2_fill, size: 28),
            ),
          ),

          body: StreamBuilder(
            stream: FirebaseHelper.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list = data
                          ?.map(
                            (e) => ChatUser.fromJson(e.data()),
                          )
                          .toList() ??
                      [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
                        // return Text("Name: ${list[index]}");
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                      "No Connections Found !!!",
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

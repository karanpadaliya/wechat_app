import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/helper/firestore_helper.dart';
import 'package:wechat_app/widgets/chat_user_card.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(CupertinoIcons.home),
        title: const Text("We Chat"),
        actions: [
          // TODO: ADD SEARCH FUNCTION
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),

          // TODO: ADD MORE FUNCTION
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),

      // TODO: ADD NEW USER
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async{
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(CupertinoIcons.chat_bubble_2_fill, size: 28),
        ),
      ),

    body: StreamBuilder(
      stream: FirestoreHelper.firebaseFirestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        final list = [];

        if(snapshot.hasData){
          final data = snapshot.data?.docs;
          for (var i in data!){
            log('Data: ${i.data()}');
            list.add(i.data()['name']);
          }
        }

        return ListView.builder(
          padding: EdgeInsets.only(top: mq.height * 0.01),
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
          return Text("Name: ${list[index]}");
        },);
      }
    ),
    );
  }
}

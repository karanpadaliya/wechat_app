import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        leading: Icon(CupertinoIcons.home),
        title: Text("We Chat"),
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
          onPressed: () {},
          child: Icon(CupertinoIcons.chat_bubble_2_fill, size: 28),
        ),
      ),
    );
  }
}

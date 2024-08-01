import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/model/chat_user.dart';

import '../main.dart';
import '../screen/chat_page.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .02, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      // color: Colors.white24,
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  user: widget.user,
                ),
              ));
        },
        child: ListTile(
          // leading: CircleAvatar(
          //   child: Icon(CupertinoIcons.person),
          // ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CircleAvatar(
              maxRadius: 20,
              backgroundColor: Color(0xff024382),
              child: CachedNetworkImage(
                width: mq.width * .1,
                height: mq.height * .1,
                imageUrl: widget.user.image ?? "No_image_found",
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
          ),
          title: Text(widget.user.name ?? "NoUserNameFound"),
          subtitle: Text(
            widget.user.about ?? "NoAboutFound",
            maxLines: 1,
          ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // trailing: Text(
          //   "12:00 PM",
          //   style: TextStyle(color: Colors.black54),
          // ),
        ),
      ),
    );
  }
}

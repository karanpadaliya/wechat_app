import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/components/my_data_util.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/model/message.dart';

import '../main.dart';
import '../screen/chat_page.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

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
        child: StreamBuilder(
          stream: FirebaseHelper.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              _message = list[0];
            }

            return ListTile(
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
              subtitle: _message != null
                  ? _message!.type == Type.image
                      ? Row(
                          children: [
                            Icon(Icons.image,size: 20,),
                            SizedBox(width: 4),
                            Text('Photo'),
                          ],
                        )
                      : Text(_message?.msg ?? "_message?.msg ??")
                  : Text(widget.user.about ?? "widget.user.about"),
              trailing: _message == null
                  ? null
                  : _message!.read!.isEmpty &&
                          _message!.fromId !=
                              FirebaseHelper.authUser
                                  .email //If in this line is firebase.authuser.emil
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context,
                              time: _message!.sent ?? "00:00"),
                          style: TextStyle(color: Colors.black54),
                        ),
              // trailing:
            );
          },
        ),
      ),
    );
  }
}

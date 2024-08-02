import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/model/message.dart';
import 'package:wechat_app/widgets/message_card.dart';

import '../main.dart';

class ChatPage extends StatefulWidget {
  final ChatUser user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _list = [];

  // for handaling message text changes
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 5,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseHelper.getAllMessages(widget.user),
                //FirebaseHelper.getAllUsers()
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return SizedBox();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];
                      // final _list = [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Say Hii! ",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff024382)),
                            ),
                            Icon(
                              Icons.waving_hand,
                              size: 40,
                              color: Color(0xff024382),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 35),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.back)),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CircleAvatar(
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
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
                // const SizedBox(
                //   height: 1,
                // ),
                Text(
                  "Last seen not available",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.smiley_fill,
                        size: 26, color: Color(0xff024382)),
                  ),

                  Expanded(
                      child: TextFormField(
                    controller: _textController,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Color(0xff024382)),
                        border: InputBorder.none),
                  )),

                  // image button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill,
                        size: 25, color: Color(0xff024382)),
                  ),
                  // image form camera button
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.camera_fill,
                        size: 25, color: Color(0xff024382)),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                FirebaseHelper.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            padding: EdgeInsets.all(8),
            minWidth: 0,
            shape: CircleBorder(),
            color: Color(0xff024382),
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 22,
            ),
          )
        ],
      ),
    );
  }
}

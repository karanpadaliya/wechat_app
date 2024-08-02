import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  List<Message> _list = [];
  final _textController = TextEditingController();
  bool _showEmoji = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: WillPopScope(
          onWillPop: () async {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
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

                          if (_list.isNotEmpty) {
                            // Scroll to the bottom whenever the messages list changes
                            return ListView.builder(
                              reverse: true,
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
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(),
                    ),
                  ),
              ],
            ),
          ),
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
              icon: Icon(CupertinoIcons.back),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CircleAvatar(
                child: CachedNetworkImage(
                  width: mq.width * .1,
                  height: mq.height * .1,
                  imageUrl: widget.user.image ?? "No_image_found",
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
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
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // FocusScope.of(context).unfocus();
                        _showEmoji = !_showEmoji;
                      });
                    },
                    icon: Icon(CupertinoIcons.smiley_fill,
                        size: 26, color: Color(0xff024382)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Color(0xff024382)),
                          border: InputBorder.none),
                      onTap: () {
                        if (_showEmoji)
                          setState(() {
                            _showEmoji = !_showEmoji;
                          });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill,
                        size: 25, color: Color(0xff024382)),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.                 //imageQuality for redusing server space
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log(image.path);
                        await FirebaseHelper.sendChatImage(
                            widget.user, File(image.path));
                      }
                    },
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
                FirebaseHelper.sendMessage(
                    widget.user, _textController.text, Type.text);
                _textController.clear();
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
          ),
        ],
      ),
    );
  }
}

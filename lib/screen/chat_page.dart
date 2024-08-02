import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Add a listener to the focus node
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });

                        return ListView.builder(
                          controller: _scrollController,
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
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.smiley_fill,
                        size: 26, color: Color(0xff024382)),
                  ),
                  Expanded(
                    child: TextFormField(
                      focusNode: _focusNode,
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
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(CupertinoIcons.photo_fill_on_rectangle_fill,
                        size: 25, color: Color(0xff024382)),
                  ),
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
                _textController.clear();
                _scrollToBottom();
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
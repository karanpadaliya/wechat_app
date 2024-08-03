import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/components/my_data_util.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/model/message.dart';

import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseHelper.authUser.email == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or another user message
  Widget _blueMessage() {
    // Update last read message if sender and receiver are different
    if (widget.message.read!.isEmpty) {
      FirebaseHelper.updateMessageReadStatus(widget.message);
      log("Msg read updated");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              left: mq.width * .03,
              right: mq.width * .02,
              top: mq.height * .01,
            ),
            margin: EdgeInsets.only(
                right: mq.width * .2,
                left: mq.width * .02,
                top: mq.height * .01),
            decoration: BoxDecoration(
              color: Color(0xff024382).withOpacity(0.1),
              border: Border.all(color: Color(0xff024382).withOpacity(0.5)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(-10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.message.type == Type.text
                    ? Text(
                        widget.message.msg ?? "Message not available",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: mq.width * .9,
                          height: mq.height * .4,
                          imageUrl: widget.message.msg ??
                              "imageUrl: widget.message.msg",
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          placeholder: (context, url) =>
                              LinearProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 65,
                          ),
                        ),
                      ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: mq.height * .005,
                          bottom: mq.height * .003,
                          right: mq.width * .02),
                      child: Text(
                        MyDateUtil.getFormattedTime(
                          context: context,
                          time: widget.message.sent ??
                              '0', // Provide a default value if null
                        ),
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                    // Optionally include the read receipt icon
                    // Padding(
                    //     padding: EdgeInsets.only(left: mq.width * .015, top: mq.height * .02),
                    //     child: Icon(Icons.done_all_outlined, size: 17, color: Colors.blue),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
              left: mq.width * .03,
              right: mq.width * .02,
              top: mq.height * .01,
            ),
            margin: EdgeInsets.only(
              left: mq.width * .2,
              right: mq.width * .02,
              top: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(-10), // Incorrect negative value
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // Ensuring left alignment within Column
              children: [
                widget.message.type == Type.text
                    ? Text(
                        widget.message.msg ?? "Message not available",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        textAlign: TextAlign.left,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          width: mq.width * .9,
                          height: mq.height * .4,
                          imageUrl: widget.message.msg ??
                              "imageUrl: widget.message.msg",
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          placeholder: (context, url) =>
                              LinearProgressIndicator(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image,
                            size: 65,
                          ),
                        ),
                      ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: mq.height * .005,
                        bottom: mq.height * .003,
                        // left: mq.width * .2, // This can be removed if not needed
                      ),
                      child: Text(
                        MyDateUtil.getFormattedTime(
                          context: context,
                          time: widget.message.sent ?? '00:00',
                        ),
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: mq.width * .01,
                      ),
                      child: widget.message.read!.isNotEmpty
                          ? Icon(
                              Icons.done_all_outlined,
                              size: 17,
                              color: Colors.blue,
                            )
                          : Icon(
                              Icons.done_all_outlined,
                              size: 17,
                              color: Colors.grey,
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

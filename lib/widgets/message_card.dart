import 'dart:developer';

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
    // Message _msg = widget.message;
    return FirebaseHelper.authUser.email == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or another user message
  Widget _blueMessage() {
    // update last read message if sender  and reciver are diffrent
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
            padding:
                EdgeInsets.only(left: mq.width * .03, right: mq.width * .015),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .005),
            decoration: BoxDecoration(
              color: Color(0xff024382).withOpacity(0.1),
              border: Border.all(color: Color(0xff024382).withOpacity(0.5)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(-10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.message.msg ?? "widget.message.msg_null"}",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .03,
                      top: mq.height * .02,
                      right: mq.width * .02,
                      bottom: mq.height * .003),
                  child: Text(
                    MyDateUtil.getFormattedTime(
                        context: context,
                        time:
                            widget.message.sent ?? "widget.message.sent_null"),
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                // Padding(
                //     padding: EdgeInsets.only(
                //         left: mq.width * .015, top: mq.height * .02),
                //     child: Icon(Icons.done_all_outlined,size: 17,color: Colors.blue,)
                // ),
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
            padding:
                EdgeInsets.only(left: mq.width * .03, right: mq.width * .015),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .005),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(-10),
                  bottomLeft: Radius.circular(30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.message.msg ?? "widget.message.msg_null"}",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .03,
                      top: mq.height * .02,
                      bottom: mq.height * .003),
                  child: Text(
                    MyDateUtil.getFormattedTime(
                        context: context,
                        time:
                            widget.message.sent ?? "widget.message.sent_null"),
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: mq.width * .015,
                      top: mq.height * .02,
                      bottom: mq.height * .003),
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
            ),
          ),
        ),
      ],
    );
  }
}

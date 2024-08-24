import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/screen/view_profile_screen.dart';

import '../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            Positioned(
              left: mq.width * .04,
              top: mq.height * .015,
              width: mq.width * .55,
              child: Text(
                "${user.name ?? "user.name??"}",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff024382)),
              ),
            ),
            Positioned(
              top: mq.height * .07,
              left: mq.width * .09,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.height * .23,
                  // height: mq.height * .2,
                  fit: BoxFit.cover,
                  imageUrl: user.image ?? "No_image_found",
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 5,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewProfilePage(user: user),
                      ));
                },
                elevation: 15,
                shape: CircleBorder(),
                minWidth: 0,
                padding: EdgeInsets.all(0),
                child: SizedBox(
                    height: 27,
                    child: Image.asset(
                      "assets/images/profile_info.png",
                      color: Color(0xff024382),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/screen/home_page.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to We Chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
            child: Image.asset("assets/images/logo.png"),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.7),
                shape: StadiumBorder(),
                elevation: 4,
              ),
              icon: Image.asset(
                "assets/images/google.png",
                height: mq.height * .03,
              ),
              label: RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: "Login with "),
                      TextSpan(
                          text: "Google",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

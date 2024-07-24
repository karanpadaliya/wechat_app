import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_app/screen/home_page.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            duration: Duration(seconds: 1),
            child: Image.asset("assets/images/logo.png"),
          ),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                "MADE IN INDIA WITH ❤",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black, letterSpacing: .5),
              )),
        ],
      ),
    );
  }
}

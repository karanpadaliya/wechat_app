import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/screen/auth/login_screen.dart';
import 'package:wechat_app/screen/home_page.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      // exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      // Check already Sign in so navigate to the homeScreen

      if(FirebaseHelper.auth.currentUser != null){
        log("\nUser: ${FirebaseHelper.auth}");
        // Navigate to the HomeScreen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }else{
        // NAvigate to the Loginpage
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }

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

          // App Logo
          Positioned(
            top: mq.height * .15,
            right: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset("assets/images/logo.png"),
          ),

          // Google login button
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
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

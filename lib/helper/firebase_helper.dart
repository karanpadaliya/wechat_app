import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/components/dialogs.dart';

class FirebaseHelper {

  FirebaseHelper._();
  static final FirebaseHelper firebaseHelper = FirebaseHelper._();

  static FirebaseAuth auth = FirebaseAuth.instance;

  // handles google login button click
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  try{
    await InternetAddress.lookup('google.com');
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await auth.signInWithCredential(credential);
  }catch(e){
    log("\nsignInWithGoogle: $e");
    Dialogs.showSnackbar(context, "Something Went Wrong (Check Internet!) ");
    return null;
  }
  }
}
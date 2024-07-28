import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/components/dialogs.dart';
import 'package:wechat_app/model/chat_user.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper firebaseHelper = FirebaseHelper._();

  static FirebaseAuth auth = FirebaseAuth.instance;

  // handles google login button click
  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
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
    } catch (e) {
      log("\nsignInWithGoogle: $e");
      Dialogs.showSnackbar(
          context, "Something Went Wrong (Check Internet!) ", Colors.redAccent);
      return null;
    }
  }

  // All the below code is FireStore
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for storing selinformation
  static late ChatUser me;

  // to return current user
  static User get authUser => auth.currentUser!;

  //   check if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.email)
            .get())
        .exists;
  }

  //   check if current user info
  static Future<void> getSelfInfo() async {
    return await firestore
        .collection('users')
        .doc(auth.currentUser!.email)
        .get()
        .then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
        } else {
          await createUser().then(
            (value) => getSelfInfo(),
          );
        }
      },
    );
  }

  // Create User
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: authUser.uid,
      name: authUser.displayName.toString(),
      email: authUser.email.toString(),
      about: "Hey, I'm using We Chat ",
      image: authUser.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(authUser.email)
        .set(chatUser.toJson());
  }

  // Getting all user in firestore
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('email', isNotEqualTo: authUser.email)
        .snapshots();
  }

  //   check if updateUserInfo
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(auth.currentUser!.email).update({
      "name": me.name,
      "about": me.about,
    });
  }
}

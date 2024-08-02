import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/components/dialogs.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/model/message.dart';

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

  // All the below code for assessing firebase storage
  static final FirebaseStorage storage = FirebaseStorage.instance;

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

  // Update Profile Picture
  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log("Extension: $ext");
    final ref = storage.ref().child("profile_picture/${authUser.email}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transfered: ${p0.bytesTransferred / 1000} kb");
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(auth.currentUser!.email)
        .update({"image": me.image});
  }

  ///****************************chat messages *******************************

  //  usefull for getting conversation id ===> Make unique ID
  static String getConversationID(String id) =>
      authUser.email.hashCode <= id.hashCode
          ? '${authUser.email}_$id'
          : '${id}_${authUser.email}';

  // Getting all messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection(
            'chats/${getConversationID(user.email ?? "getConversationID_error")}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg) async {
    // Message sending time is also used for ID
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // Get the user email and authenticated user email
    final toId = user.email ?? "toId_error";
    final fromId = authUser.email ?? "fromId_error";

    // Ensure emails are not null or empty
    if (toId == "toId_error" || fromId == "fromId_error") {
      throw Exception("Invalid user email for message sending.");
    }

    // Message send
    final Message message = Message(
      toId: toId,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: fromId,
      sent: time,
    );

    // Properly form the document path
    final conversationID = getConversationID(toId);
    if (conversationID.isEmpty) {
      throw Exception("Invalid conversation ID.");
    }

    final ref = firestore.collection('chats/$conversationID/messages');

    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection(
            'chats/${getConversationID(message.fromId ?? "message.fromId??_notFound")}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection(
            'chats/${getConversationID(user.email ?? "message.fromId??_notFound")}/messages/')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/model/message.dart';
import 'package:wechat_app/screen/home_page.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper firebaseHelper = FirebaseHelper._();

  static FirebaseAuth auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  // Handles Google login button click
  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // Check for internet connection
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your internet connection and try again.')),
        );
        return null;
      }

      // Sign out the previous Google session if there is any.
      await googleSignIn.signOut();

      // Attempt Google sign-in
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      log('Google User: ${googleUser?.email}');

      if (googleUser == null) {
        log('Google Sign-In canceled');
        return null; // User canceled sign-in
      }

      // Fetch authentication token from the Google account.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      log('Google Authentication: ${googleAuth.accessToken}, ${googleAuth.idToken}');

      // Create Firebase credentials from Google sign-in token.
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Google Credentials: ${credential.providerId}');

      // Sign in to Firebase with the Google credential.
      final UserCredential userCredential = await auth.signInWithCredential(credential);

      // Check if the user is successfully signed in
      if (userCredential.user != null) {
        log('User signed in: ${userCredential.user!.email}');

        // Optionally add user to Firestore or perform other actions here
        // await addUserToFirestore(userCredential.user!);

        // Return the userCredential if everything is successful
        return userCredential;
      } else {
        log('No user found after sign-in');
        return null;
      }
    } catch (e) {
      // Handle FirebaseAuthException
      if (e is FirebaseAuthException) {
        log('FirebaseAuthException: ${e.code} - ${e.message}');
      }
      // Handle PlatformException
      else if (e is PlatformException) {
        log('PlatformException: ${e.code} - ${e.message} - ${e.details}');
      }
      // Handle generic errors
      else {
        log('Error during Google Sign-In: $e');
      }

      // Display error message via a SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login error: ${e.toString()}')),
        );
      }
      return null; // Return null on error
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
          await getFirebaseMessagingToken();
          FirebaseHelper.updateActiveStatus(true);
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
      log("Data Transferred: ${p0.bytesTransferred / 1000} kb");
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
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg, Type type) async {
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
      type: type,
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
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat images
  // Update Profile Picture
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.email ?? "sendChatImage: getConversationID(chatUser.email??")}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    // final ref = storage.ref().child("images/${getConversationID(
    //     chatUser.email ?? "message.fromId??_notFound") / ${DateTime}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000} kb");
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // Last seen || ONLINE & OFFLINE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('email', isEqualTo: chatUser.email)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(authUser.email).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

//   ********************* Firebase Messaging ***********************

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log("Push Token $t");
      }
    });
  }
}
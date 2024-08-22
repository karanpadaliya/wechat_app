import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_app/components/dialogs.dart';
import 'package:wechat_app/helper/firebase_helper.dart';
import 'package:wechat_app/model/chat_user.dart';
import 'package:wechat_app/screen/auth/login_screen.dart';
import 'package:wechat_app/widgets/chat_user_card.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List<ChatUser> list = [];
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Profile Screen"),
        ),

        // TODO: ADD NEW USER
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);

              await FirebaseHelper.updateActiveStatus(false);

              await FirebaseAuth.instance.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      // for hiding progreess dialog
                      Navigator.pop(context);

                      // for moving home screen
                      Navigator.pop(context);

                      FirebaseHelper.auth = FirebaseAuth.instance;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                  );
                },
              );
            },
            label: Text("Logout"),
            icon: Icon(Icons.logout, size: 28),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            elevation: 5,
            shape: const StadiumBorder(),
          ),
        ),

        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height * .03),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: Image.file(
                                File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(mq.height * .1),
                              child: CachedNetworkImage(
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image ?? "No_image_found",
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: Icon(CupertinoIcons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 1,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.height * .03),
                  Text(
                    widget.user.email ?? "EmailNotFound",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: mq.height * .05),
                  TextFormField(
                    style: TextStyle(color: Colors.black, letterSpacing: 1),
                    initialValue: widget.user.name,
                    onSaved: (val) => FirebaseHelper.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black), // Change the color here
                      ),
                      fillColor: Colors.black,
                      hintText: "eg. Happy Singh",
                      label: Text(
                        "Name",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * .02),
                  TextFormField(
                    style: TextStyle(color: Colors.black, letterSpacing: 1),
                    initialValue: widget.user.about,
                    onSaved: (val) => FirebaseHelper.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors.black), // Change the color here
                      ),
                      fillColor: Colors.black,
                      hintText: "eg. Feeling Happy",
                      label: Text(
                        "About",
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height * .05),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FirebaseHelper.updateUserInfo().then(
                          (value) {
                            Dialogs.showSnackbar(context,
                                "Profile Updated Sucessfully", Colors.green);
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: StadiumBorder(),
                        backgroundColor: Color(0xff024382),
                        foregroundColor: Colors.white,
                        minimumSize: Size(mq.width * .32, mq.height * .050)),
                    icon: Icon(Icons.edit),
                    label: Text(
                      "UPDATE",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
          children: [
            Text(
              "Pick Profile Picture",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: mq.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.                 //imageQuality for redusing server space
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      if (image != null) {
                        log(image.path);
                        setState(() {
                          _image = image.path;
                        });
                        FirebaseHelper.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/gallery.png")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.                //imageQuality for redusing server space
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 80);
                      if (image != null) {
                        log(image.path);
                        setState(() {
                          _image = image.path;
                        });
                        FirebaseHelper.updateProfilePicture(File(_image!));
                        Navigator.pop(context);
                      }
                    },
                    child: Image.asset("assets/images/camera.png")),
              ],
            ),
          ],
        );
      },
    );
  }
}

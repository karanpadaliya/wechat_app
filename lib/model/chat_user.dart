// To parse this JSON data, do
//
//     final chatUser = chatUserFromJson(jsonString);

import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
  String? image;
  String? about;
  String? name;
  String? createdAt;
  String? id;
  bool? isOnline;
  String? lastActive;
  String? pushToken;
  String? email;

  ChatUser({
    this.image,
    this.about,
    this.name,
    this.createdAt,
    this.id,
    this.isOnline,
    this.lastActive,
    this.pushToken,
    this.email,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
    image: json["image"],
    about: json["about"],
    name: json["name"],
    createdAt: json["created_at"],
    id: json["id"],
    isOnline: json["is_online"],
    lastActive: json["last_active"],
    pushToken: json["push_token"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "about": about,
    "name": name,
    "created_at": createdAt,
    "id": id,
    "is_online": isOnline,
    "last_active": lastActive,
    "push_token": pushToken,
    "email": email,
  };
}

import 'dart:typed_data';
import 'package:call_app/constants/enum.dart';
import 'package:call_app/model/firebase_chat_model.dart';
import 'package:call_app/model/firebase_message_model.dart';
import 'package:call_app/service/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String name,
    required String image,
    required String email,
    required String about,
    required String uid,
  }) async {
    final user = FirebaseChatModel(
      uid: uid,
      email: email,
      name: name,
      about: about,
      image: image,
      isOnline: true,
      lastActive: DateTime.now(),
    );

    await firestore.collection('verifiedUsers').doc(uid).set(user.toJson());
  }

  static Future<void> addTextMessage({
    required String content,
    required String receiverId,
  }) async {
    final message = FirebaseMessageModel(
      content: content,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> addImageMessage({
    required String receiverId,
    required Uint8List file,
  }) async {
    final image = await FirebaseStorageService.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = FirebaseMessageModel(
      content: image,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await _addMessageToChat(receiverId, message);
  }

  static Future<void> _addMessageToChat(
    String receiverId,
    FirebaseMessageModel message,
  ) async {
    await firestore
        .collection('verifiedUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .add(message.toJson());

    await firestore
        .collection('verifiedUsers')
        .doc(receiverId)
        .collection('chat')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .add(message.toJson());
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await firestore
          .collection('verifiedUsers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  static Future<List<FirebaseChatModel>> searchUser(String name) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('verifiedUsers')
        .where("name", isGreaterThanOrEqualTo: name)
        .get();

    return snapshot.docs
        .map((doc) => FirebaseChatModel.fromJson(doc.data()))
        .toList();
  }
}

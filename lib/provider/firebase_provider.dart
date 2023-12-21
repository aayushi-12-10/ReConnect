import 'package:call_app/model/firebase_chat_model.dart';
import 'package:call_app/model/firebase_message_model.dart';
import 'package:call_app/service/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();
  List<FirebaseChatModel> users = [];
  List<FirebaseChatModel> chatUsers = [];
  FirebaseChatModel? user;
  List<FirebaseMessageModel> messages = [];
  List<FirebaseChatModel> search = [];

  List<FirebaseChatModel> getAllUsers() {
    FirebaseFirestore.instance
        .collection('verifiedUsers')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((users) {
      this.users = users.docs
          .map((doc) => FirebaseChatModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
    return users;
  }

  FirebaseChatModel? getUserById(String userId) {
    FirebaseFirestore.instance
        .collection('verifiedUsers')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      this.user = FirebaseChatModel.fromJson(user.data()!);
      notifyListeners();
    });
    return user;
  }

  List<FirebaseMessageModel> getMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('verifiedUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages = messages.docs
          .map((doc) => FirebaseMessageModel.fromJson(doc.data()))
          .toList();
      notifyListeners();

      scrollDown();
    });
    return messages;
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });

  Future<void> searchUser(String name) async {
    search = await FirebaseFirestoreService.searchUser(name);
    notifyListeners();
  }

  List<FirebaseChatModel> getAllChatUsers() {
    List<FirebaseChatModel> result = [];

    FirebaseFirestore.instance
        .collection('verifiedUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chat')
        .snapshots(includeMetadataChanges: true)
        .listen((chatUsers) {
      this.chatUsers = chatUsers.docs
          .map((doc) => FirebaseChatModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });

    if (chatUsers.isNotEmpty) {
      for (int i = 0; i < chatUsers.length; i++) {
        user = getUserById(chatUsers[i].uid);
        result.add(user!);
      }
    }

    return result;
  }
}

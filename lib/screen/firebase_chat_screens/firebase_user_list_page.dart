import 'package:call_app/provider/firebase_provider.dart';
import 'package:call_app/service/firebase_firestore_service.dart';
import 'package:call_app/service/notification_service.dart';
import 'package:call_app/widget/firebase_user_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseUserListPage extends StatefulWidget {
  const FirebaseUserListPage({super.key});

  @override
  State<FirebaseUserListPage> createState() => _FirebaseUserListPageState();
}

class _FirebaseUserListPageState extends State<FirebaseUserListPage>
    with WidgetsBindingObserver {
  final notificationService = NotificationsService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
    notificationService.firebaseNotification(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;

      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FirebaseProvider>(
        builder: (context, value, child) {
          if (value.users.isEmpty) {
            return const Center(
              child: Text(
                "Waiting for more people to join...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: value.users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => value.users[index].uid !=
                      FirebaseAuth.instance.currentUser?.uid
                  ? FirebaseUserItemWidget(user: value.users[index])
                  : const SizedBox(),
            );
          }
        },
      ),
    );
  }
}

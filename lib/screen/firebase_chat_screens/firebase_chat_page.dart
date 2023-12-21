import 'package:call_app/provider/firebase_provider.dart';
import 'package:call_app/widget/firebase_chat_messages_widget.dart';
import 'package:call_app/widget/firebase_chat_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseChatPage extends StatefulWidget {
  const FirebaseChatPage({super.key, required this.userId});

  final String userId;

  @override
  State<FirebaseChatPage> createState() => _FirebaseChatPageState();
}

class _FirebaseChatPageState extends State<FirebaseChatPage> {
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false)
      ..getUserById(widget.userId)
      ..getMessages(widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FirebaseChatMessagesWidget(receiverId: widget.userId),
            FirebaseChatTextFieldWidget(receiverId: widget.userId),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Consumer<FirebaseProvider>(
          builder: (context, value, child) => value.user != null
              ? Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(value.user!.image),
                      radius: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Text(
                          value.user!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value.user!.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: value.user!.isOnline
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      );
}

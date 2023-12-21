import 'package:call_app/constants/enum.dart';
import 'package:call_app/provider/firebase_provider.dart';
import 'package:call_app/widget/empty_widget.dart';
import 'package:call_app/widget/firebase_message_bubble_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseChatMessagesWidget extends StatelessWidget {
  const FirebaseChatMessagesWidget({super.key, required this.receiverId});
  final String receiverId;

  @override
  Widget build(BuildContext context) => Consumer<FirebaseProvider>(
        builder: (context, value, child) => value.messages.isEmpty
            ? const Expanded(
                child: EmptyWidget(icon: Icons.waving_hand, text: 'Say Hello!'),
              )
            : Expanded(
                child: ListView.builder(
                  controller:
                      Provider.of<FirebaseProvider>(context, listen: false)
                          .scrollController,
                  itemCount: value.messages.length,
                  itemBuilder: (context, index) {
                    final isTextMessage =
                        value.messages[index].messageType == MessageType.text;
                    final isMe = receiverId != value.messages[index].senderId;

                    return isTextMessage
                        ? FirebaseMessageBubbleWidget(
                            isMe: isMe,
                            message: value.messages[index],
                            isImage: false,
                          )
                        : FirebaseMessageBubbleWidget(
                            isMe: isMe,
                            message: value.messages[index],
                            isImage: true,
                          );
                  },
                ),
              ),
      );
}

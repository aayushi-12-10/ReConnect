import 'package:timeago/timeago.dart' as timeago;
import 'package:call_app/model/firebase_message_model.dart';
import 'package:flutter/material.dart';

class FirebaseMessageBubbleWidget extends StatelessWidget {
  const FirebaseMessageBubbleWidget({
    super.key,
    required this.isMe,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final bool isImage;
  final FirebaseMessageModel message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey : Colors.purple,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
          ),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              isImage
                  ? Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(message.content),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Text(message.content,
                      style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                timeago.format(message.sentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
}

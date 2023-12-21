import 'package:call_app/screen/firebase_chat_screens/firebase_chat_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:call_app/model/firebase_chat_model.dart';
import 'package:flutter/material.dart';

class FirebaseChatItemWidget extends StatefulWidget {
  const FirebaseChatItemWidget({super.key, required this.user});

  final FirebaseChatModel user;

  @override
  State<FirebaseChatItemWidget> createState() => _FirebaseChatItemWidgetState();
}

class _FirebaseChatItemWidgetState extends State<FirebaseChatItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FirebaseChatPage(userId: widget.user.uid),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(widget.user.image),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                backgroundColor:
                    widget.user.isOnline ? Colors.green : Colors.grey,
                radius: 5,
              ),
            ),
          ],
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Last Active : ${timeago.format(widget.user.lastActive)}',
          maxLines: 2,
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 15,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

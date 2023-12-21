import 'package:call_app/screen/firebase_chat_screens/firebase_chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:call_app/model/firebase_chat_model.dart';
import 'package:flutter/material.dart';

class FirebaseUserItemWidget extends StatefulWidget {
  const FirebaseUserItemWidget({super.key, required this.user});

  final FirebaseChatModel user;

  @override
  State<FirebaseUserItemWidget> createState() => _FirebaseUserItemWidgetState();
}

class _FirebaseUserItemWidgetState extends State<FirebaseUserItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (builder) => bottomSheet(),
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

  Widget bottomSheet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: buildImage(),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.user.email,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.user.name,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 20,
                right: 20,
              ),
              child: Text(
                widget.user.about,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('verifiedUsers')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('chat')
                    .doc(widget.user.uid)
                    .set({
                      'sender': FirebaseAuth.instance.currentUser!.uid,
                      'receiver': widget.user.uid,
                    });

                if (context.mounted) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FirebaseChatPage(userId: widget.user.uid),
                    ),
                  );
                }
              },
              child: const Text(
                "Chat now",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(widget.user.image);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }
}

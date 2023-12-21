import 'dart:typed_data';
import 'package:call_app/service/firebase_firestore_service.dart';
import 'package:call_app/service/media_service.dart';
import 'package:call_app/service/notification_service.dart';
import 'package:call_app/widget/firebase_text_form_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseChatTextFieldWidget extends StatefulWidget {
  const FirebaseChatTextFieldWidget({super.key, required this.receiverId});

  final String receiverId;

  @override
  State<FirebaseChatTextFieldWidget> createState() =>
      _FirebaseChatTextFieldWidgetState();
}

class _FirebaseChatTextFieldWidgetState
    extends State<FirebaseChatTextFieldWidget> {
  final controller = TextEditingController();
  final notificationsService = NotificationsService();
  Uint8List? file;

  @override
  void initState() {
    notificationsService.getReceiverToken(widget.receiverId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: FirebaseCustomTextFormFieldWidget(
              controller: controller,
              hintText: 'Add Message...',
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 20,
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: () => _sendText(context),
            ),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 20,
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              onPressed: _sendImage,
            ),
          ),
        ],
      );

  Future<void> _sendText(BuildContext context) async {
    if (controller.text.isNotEmpty) {
      await FirebaseFirestoreService.addTextMessage(
        receiverId: widget.receiverId,
        content: controller.text,
      );
      await notificationsService.sendNotification(
        body: controller.text,
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
      controller.clear();
      if (context.mounted) {
        FocusScope.of(context).unfocus();
      }
    }
    if (context.mounted) {
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _sendImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirebaseFirestoreService.addImageMessage(
        receiverId: widget.receiverId,
        file: file!,
      );
      await notificationsService.sendNotification(
        body: 'image........',
        senderId: FirebaseAuth.instance.currentUser!.uid,
      );
    }
  }
}

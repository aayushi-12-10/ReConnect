import 'package:call_app/service/firebase_storage_service.dart';
import 'package:call_app/service/media_service.dart';
import 'package:call_app/widget/about_profile_widget.dart';
import 'package:call_app/widget/profile_image_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String newAbout = '';
  final user = FirebaseAuth.instance.currentUser!;
  Uint8List? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("verifiedUsers")
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(
                  height: 10,
                ),
                ProfileWidget(
                  imagePath: userData['image'],
                  isEdit: true,
                  onPressed: () {
                    _updateImage();
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  user.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    "My Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                AboutProfileWidget(
                  text: userData['name'],
                  isEdit: true,
                  sectionName: 'Name',
                  onPressed: () => editField('Name'),
                ),
                AboutProfileWidget(
                  text: userData['about'],
                  isEdit: true,
                  sectionName: 'About',
                  onPressed: () => editField('About'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error${snapshot.error}"),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<void> _updateImage() async {
    final pickedImage = await MediaService.pickImage();
    setState(() => file = pickedImage);

    if (file != null) {
      final image = await FirebaseStorageService.uploadImage(
          file!, 'image/profile/${FirebaseAuth.instance.currentUser!.uid}');

      await FirebaseFirestore.instance
          .collection('verifiedUsers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'image': image});
    }
  }

  Future<void> editField(String field) async {
    String newValue = '';
    bool flag = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              flag = true;
              Navigator.of(context).pop(newValue);
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (flag && newValue.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('verifiedUsers')
          .doc(user.uid)
          .update({field.toLowerCase(): newValue});
    }
  }
}

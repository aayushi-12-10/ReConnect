import 'package:call_app/provider/firebase_provider.dart';
import 'package:call_app/widget/empty_widget.dart';
import 'package:call_app/widget/firebase_text_form_field_widget.dart';
import 'package:call_app/widget/firebase_user_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseUsersSearchPage extends StatefulWidget {
  const FirebaseUsersSearchPage({super.key});

  @override
  State<FirebaseUsersSearchPage> createState() =>
      _FirebaseUsersSearchPageState();
}

class _FirebaseUsersSearchPageState extends State<FirebaseUsersSearchPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          foregroundColor: Colors.black,
          title: const Text(
            'Users Search',
            style: TextStyle(fontSize: 25,color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              FirebaseCustomTextFormFieldWidget(
                controller: controller,
                hintText: 'Search',
                onChanged: (val) =>
                    Provider.of<FirebaseProvider>(context, listen: false)
                        .searchUser(val),
              ),
              Consumer<FirebaseProvider>(
                builder: (context, value, child) => Expanded(
                  child: controller.text.isEmpty
                      ? const EmptyWidget(
                          icon: Icons.search, text: 'Search for User')
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: value.search.length,
                          itemBuilder: (context, index) =>
                              value.search[index].uid !=
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? FirebaseUserItemWidget(
                                      user: value.search[index])
                                  : const SizedBox(),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
}

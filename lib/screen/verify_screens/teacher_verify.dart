import 'package:call_app/constants/routes.dart';
import 'package:call_app/model/firebase_chat_model.dart';
import 'package:call_app/service/firebase_storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherVerifyPage extends StatefulWidget {
  const TeacherVerifyPage({super.key});

  @override
  State<TeacherVerifyPage> createState() => _TeacherVerifyPageState();
}

class _TeacherVerifyPageState extends State<TeacherVerifyPage> {
  bool visible = false;
  bool _isObscure4 = true;
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController passPhrase = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "What's the secret Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            obscureText: _isObscure4,
                            controller: passPhrase,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure4
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure4 = !_isObscure4;
                                    });
                                  }),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                left: 14.0,
                                bottom: 8.0,
                                top: 8.0,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                setState(() {
                                  visible = false;
                                });
                                return "Password cannot be empty";
                              } else if (!regex.hasMatch(value)) {
                                setState(() {
                                  visible = false;
                                });
                                return ("please enter valid password min. 6 character");
                              } else if (passPhrase.text != 'IIITdwd!123456') {
                                setState(() {
                                  visible = false;
                                });
                                return "Wrong Password :)";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              passPhrase.text = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  setState(() {
                                    visible = true;
                                  });
                                  verifyTeacher();
                                },
                                color: const Color.fromARGB(255, 208, 47, 240),
                                child: const Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              MaterialButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () async {
                                  setState(() {
                                    visible = true;
                                  });
                                  try {
                                    await _auth.signOut();
                                  } finally {
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        loginRoute,
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                color: const Color.fromARGB(255, 208, 47, 240),
                                child: const Text(
                                  "Back",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            elevation: 5.0,
                            height: 40,
                            onPressed: () {
                              setState(() {
                                visible = true;
                              });
                              deleteUser();
                            },
                            color: const Color.fromARGB(255, 208, 47, 240),
                            child: const Text(
                              "Delete Account",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: const CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyTeacher() async {
    if (_formkey.currentState!.validate()) {
      try {
        await _store
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'isVerified': true});

        final userDoc = await _store
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .then((value) => value.data());

        final file =
            (await rootBundle.load('assets/user.png')).buffer.asUint8List();

        final image = await FirebaseStorageService.uploadImage(
            file, 'image/profile/${_auth.currentUser!.uid}');

        final user = FirebaseChatModel(
          uid: currentUser.uid,
          email: currentUser.email!,
          name: userDoc!['name'],
          about: "Teacher of IIIT Dharwad",
          image: image,
          isOnline: false,
          lastActive: DateTime.now(),
        );

        await _store
            .collection('verifiedUsers')
            .doc(currentUser.uid)
            .set(user.toJson());
      } finally {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            teacherHomeRoute,
            (route) => false,
          );
        }
      }
    }
  }

  void deleteUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .delete();
      await user.delete();
    } finally {
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (route) => false,
        );
      }
    }
  }
}

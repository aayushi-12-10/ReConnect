import 'package:call_app/model/firebase_chat_model.dart';
import 'package:call_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:call_app/service/firebase_storage_service.dart';
import 'package:flutter/services.dart' show rootBundle;

class TeacherVerifyStudentPage extends StatefulWidget {
  const TeacherVerifyStudentPage({super.key});

  @override
  State<TeacherVerifyStudentPage> createState() => _TeacherVerifyStudentPageState();
}

class _TeacherVerifyStudentPageState extends State<TeacherVerifyStudentPage> {
  final _store = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'Student')
      .where('isVerified', isEqualTo: false)
      .snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text("something went wrong");
          } else {
            final studentDocs = snapshot.data!.docs;
            final List<UserModel> students = [];
            for (var student in studentDocs) {
              students.insert(0, UserModel.fromMap(student.data() as dynamic));
            }

            if (students.isEmpty) {
              return const Center(
                child: Text(
                  "Horray! There is nobody to verify",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return GestureDetector(
                      onTap: () {
                        _showVerifyDialog(student);
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            child: SingleChildScrollView(
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                    "Name: ${student.name}\nRoll Number:${student.rollNumber}\nEmail: ${student.email!}"),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _loadStudents() async {
    setState(() {});
  }

  Future<void> _updateStudent(UserModel student) async {
    await _store.collection('users').doc(student.uid).update(
      {'isVerified': true},
    );

    final file =
        (await rootBundle.load('assets/user.png')).buffer.asUint8List();

    final image = await FirebaseStorageService.uploadImage(
        file, 'image/profile/${student.uid}');

    final user = FirebaseChatModel(
      uid: student.uid!,
      email: student.email!,
      name: student.name!,
      about: "Student of IIIT Dharwad",
      image: image,
      isOnline: false,
      lastActive: DateTime.now(),
    );

    await _store
        .collection('verifiedUsers')
        .doc(student.uid)
        .set(user.toJson());

    _loadStudents();
  }

  Future<void> _deleteStudent(UserModel student) async {
    await _store.collection('users').doc(student.uid).delete();
    _loadStudents();
  }

  Future<void> _showVerifyDialog(UserModel student) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Verification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Do you want to accept '${student.name}'?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _updateStudent(student);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                _deleteStudent(student);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
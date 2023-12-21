import 'package:call_app/constants/routes.dart';
import 'package:call_app/firebase_options.dart';
import 'package:call_app/provider/firebase_provider.dart';
import 'package:call_app/screen/home_screens/student_home_page.dart';
import 'package:call_app/screen/home_screens/teacher_home_screen.dart';
import 'package:call_app/screen/auth_screens/forgot_screen.dart';
import 'package:call_app/screen/auth_screens/login_page.dart';
import 'package:call_app/screen/auth_screens/register_page.dart';
import 'package:call_app/screen/verify_screens/student_verify.dart';
import 'package:call_app/screen/verify_screens/teacher_verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(const MainApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: "ReConnect",
        theme: ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(color: Colors.blue),
        ),
        home: const LoginPage(),
        routes: {
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const RegisterPage(),
          forgotPasswordRoute: (context) => const ForgotPasswordPage(),
          studentHomeRoute: (context) => const StudentHomePage(),
          teacherHomeRoute: (context) => const TeacherHomePage(),
          teacherVerifyRoute: (context) => const TeacherVerifyPage(),
          studentVerifyRoute: (context) => const StudentVerifyPage(),
        },
      ),
    );
  }
}

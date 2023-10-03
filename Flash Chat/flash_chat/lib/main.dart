import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/pages/chat_page.dart';
import 'package:flash_chat/pages/sign_in_page.dart';
import 'package:flash_chat/pages/sign_up_page.dart';
import 'package:flash_chat/pages/welcome_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      initialRoute:  WelcomePage.routeName,
      routes: {
        WelcomePage.routeName: (context) => const WelcomePage(),
        SignUpPage.routeName:(context) => const SignUpPage(),
        SignInPage.routeName:(context) => const SignInPage(),
        ChatPage.routeName:(context) => const ChatPage(),
      },
    );
  }
}

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:flutter_chat/features/chat_screen.dart/chat_messages.dart.dart';
import 'package:flutter_chat/features/chat_screen.dart/new_messages.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthController _auth = Get.put(AuthController());

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();

    log('token : $token', name: 'fcm'); //send this token (via HTTP or the Firestore SDK) to a backend
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FlutterChat',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              _auth.signOut();
              Fluttertoast.showToast(msg: 'logged out');
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Icon(Icons.exit_to_app_rounded),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessages(),
        ],
      ),
    );
  }
}

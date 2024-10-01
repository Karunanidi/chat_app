import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final AuthController _auth = Get.put(AuthController());

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logged In!'),
          ],
        ),
      ),
    );
  }
}

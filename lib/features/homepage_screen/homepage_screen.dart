import 'package:flutter/material.dart';
import 'package:flutter_chat/core/component/image_picker.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImagePickerWidget()
          ],
        ),
      ),
    );
  }
}

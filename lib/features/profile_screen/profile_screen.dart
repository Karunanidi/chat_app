import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat/core/component/custom_text_field.dart';
import 'package:flutter_chat/core/component/image_picker.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:flutter_chat/features/chat_screen.dart/chat.dart';
import 'package:flutter_chat/features/profile_screen/controller/profile_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _auth = Get.put(AuthController());
  final username = TextEditingController();
  final ProfileController _profileController = Get.put(ProfileController());

  void _submitProfile() {
    if (username.text.isNotEmpty ||
        _profileController.selectedImage.value != null) {
      _profileController.username.value = username.text;
      _profileController.uploadImageToFirebaseStorage();

      Fluttertoast.showToast(msg: 'profile saved');
      Get.offAll(() => const ChatScreen());
      log('username: ${username.text}');
    } else {
      Fluttertoast.showToast(msg: 'Harap lengkapi data pengguna');
    }
  }

  @override
  void dispose() {
    username.dispose();
    super.dispose();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImagePickerWidget(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextField(
                textController: username,
                label: 'username',
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
                onPressed: _submitProfile, child: const Text('save profile'))
          ],
        ),
      ),
    );
  }
}

// File path: screens/auth_check_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth_screen/auth_screen.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:flutter_chat/features/chat_screen.dart/chat.dart';
import 'package:flutter_chat/features/chat_screen.dart/chat_messages.dart.dart';
import 'package:flutter_chat/features/profile_screen/profile_screen.dart';
import 'package:get/get.dart';

class AuthCheckScreen extends StatelessWidget {
  final AuthController _authController = Get.find();

  AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          // Display a loading spinner while checking auth state
          if (_authController.isLoading.value) {
            return const CircularProgressIndicator();
          }

          // If there is an error, show the error message
          if (_authController.errorMessage.value.isNotEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                Text(
                  _authController.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _authController.retryAuthCheck,
                  child: const Text('Retry'),
                ),
              ],
            );
          }

          // If not loading or error, redirect based on user auth status
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_authController.isAuthenticated.value) {
              Get.offAll(() => const ProfileScreen());
            } else {
              Get.offAll(() => AuthScreen());
            }
          });

          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.run_circle_outlined,
                size: 150,
              )
            ],
          );
        }),
      ),
    );
  }
}

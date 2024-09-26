import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat/features/auth_screen/auth_screen.dart';
import 'package:flutter_chat/features/homepage_screen/homepage_screen.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables for state management
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isAuthenticated = false.obs;
  var isLoginMode = true.obs;

  // Called when the controller is initialized
  @override
  void onInit() {
    super.onInit();
    _checkAuthState();
  }

  // Check if user is already logged in
  void _checkAuthState() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      _auth.authStateChanges().listen((User? user) {
        isLoading.value = false;

        if (user != null) {
          // If user is logged in, set authenticated to true
          isAuthenticated.value = true;
        } else {
          // User is not logged in
          isAuthenticated.value = false;
        }
      });
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to check authentication. Please try again.';
    }
  }

  // Retry authentication check if network or other error occurs
  void retryAuthCheck() {
    _checkAuthState();
  }

  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // On successful login, go to the homepage
      log('userCredentials: $credentials');
      isAuthenticated.value = true;
      Get.offAll(() => const HomePageScreen());
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Authentication failed';
    } finally {
      isLoading.value = false;
    }
  }

  // Sign up method
  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log('userCredentialsNewUser: $credentials');

      // On successful sign up, go to the homepage
      isAuthenticated.value = true;
      Get.offAll(() => const HomePageScreen());
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Sign-up failed';
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
    isAuthenticated.value = false;
    Get.offAll(() => AuthScreen());
  }

  // Toggle between login and sign-up mode
  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive variables for state management
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var isLoginMode = true.obs;

  // Sign in method
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; 
      await _auth.signInWithEmailAndPassword(email: email, password: password);
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
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'Authentication failed';
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle between login and sign-up
  void toggleAuthMode() {
    isLoginMode.value = !isLoginMode.value;
  }
}
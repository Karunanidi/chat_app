import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth_screen/controller/auth_controller.dart';
import 'package:get/get.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    _formKey.currentState?.save();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_authController.isLoginMode.value) {
      _authController.signIn(email, password);
    } else {
      _authController.signUp(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(40.0),
                child: const Icon(
                  Icons.message_rounded,
                  size: 70,
                ),
              ),
              Card(
                margin: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),

                          // Loading indicator
                          Obx(() {
                            if (_authController.isLoading.value) {
                              return const CircularProgressIndicator.adaptive();
                            } else {
                              return ElevatedButton(
                                onPressed: _trySubmit,
                                child: Obx(() => Text(
                                    _authController.isLoginMode.value
                                        ? 'Login'
                                        : 'Sign Up')),
                              );
                            }
                          }),

                          // Error message
                          Obx(() {
                            if (_authController.errorMessage.value.isNotEmpty) {
                              return Text(
                                _authController.errorMessage.value,
                                style: const TextStyle(color: Colors.red),
                              );
                            }
                            return Container();
                          }),

                          // Toggle between login and sign-up
                          TextButton(
                            onPressed: _authController.toggleAuthMode,
                            child: Obx(() => Text(
                                  _authController.isLoginMode.value
                                      ? 'Create an account'
                                      : 'I already have an account',
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

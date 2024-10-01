import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textController,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  final TextEditingController textController;
  final String? label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(labelText: label ?? 'Input'),
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      validator: validator,
    );
  }
}

class EmailTextField extends CustomTextField {
  EmailTextField({
    super.key,
    required super.textController,
    super.label = 'Email Address',
  }) : super(
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || !value.contains('@')) {
              return 'Silakan masukkan alamat email yang valid.';
            }
            return null;
          },
        );
}

class PasswordTextField extends CustomTextField {
  PasswordTextField({
    super.key,
    required super.textController,
    super.label = 'Password',
  }) : super(
          obscureText: true,
          validator: (value) {
            if (value == null || value.length < 6) {
              return 'Password harus memiliki setidaknya 6 karakter.';
            }
            return null;
          },
        );
}

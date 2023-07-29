// flutter
import 'package:flutter/material.dart';
// components
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/details/rounded_password_field.dart';

class PasswordFieldAndButtonScreen extends StatelessWidget {
  const PasswordFieldAndButtonScreen({
    Key? key,
    required this.appberTitle,
    required this.buttonText,
    required this.textEditingController,
    required this.toggleObscureText,
    required this.shadowColor,
    required this.buttonColor,
    required this.obscureText,
    required this.onPressed,
    required this.onChanged,
  }) : super(key: key);

  final String appberTitle, buttonText;
  final TextEditingController textEditingController;
  final void Function()? toggleObscureText;
  final Color shadowColor, buttonColor;
  final bool obscureText;
  final void Function()? onPressed;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appberTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedPasswordField(
              onChanged: onChanged,
              passwordEditingController: textEditingController,
              obscureText: obscureText,
              toggleIsObscureText: toggleObscureText,
              borderColor: Colors.black,
              shadowColor: shadowColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            child: RoundedButton(
              //まず再認証をする
              //場合によってはupdatePasswordPageに飛ばしたり、updateEmailPageに飛ばしたりする
              onPressed: onPressed,
              widthRate: 0.8,
              color: buttonColor,
              text: buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
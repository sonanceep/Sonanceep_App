// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/models/auth/update_password_model.dart';
import 'package:sonanceep_sns/views/auth/components/password_field_and_button_screen.dart';

class UpdatePasswordPage extends ConsumerWidget {
  const UpdatePasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final UpdatePasswordModel updatePasswordModel = ref.watch(updatePasswordProvider);
    final TextEditingController textEditingController = TextEditingController(text: updatePasswordModel.newPassword);
    final TextEditingController passwordEditingController = TextEditingController(text: updatePasswordModel.newPassword);

    return PasswordFieldAndButtonScreen(
      appberTitle: updatePasswordPageTitle,
      buttonText: updatePasswordText,
      textEditingController: textEditingController,
      passwordEditingController: passwordEditingController,
      toggleObscureText: () => updatePasswordModel.toggleIsObscure(),
      shadowColor: Colors.green.withOpacity(0.3),
      buttonColor: Colors.orange.withOpacity(0.5),
      obscureText: updatePasswordModel.isObscure,
      onPressed: () async => await updatePasswordModel.updatePassword(context: context),
      onChanged: (value) => updatePasswordModel.newPassword = value,
    );
  }
}
// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/models/auth/verify_password_reset_model.dart';
import 'package:sonanceep_sns/views/auth/components/text_field_and_button_screen.dart';

class VerifyPasswordResetPage extends ConsumerWidget {
  const VerifyPasswordResetPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VerifyPasswordResetModel verifyPasswordResetModel = ref.watch(verifyPasswordResetProvider);
    final TextEditingController controller = TextEditingController(text: verifyPasswordResetModel.email);
    return TextFieldAndButtonScreen(
      appberTitle: 'パスワードを忘れた場合',
      buttonText: 'パスワードを変更するメールを送信する',
      hintText: 'ログインに使用したいメールアドレス',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      shadowColor: Colors.red.withOpacity(0.3),
      buttonColor: Colors.deepOrangeAccent.withOpacity(0.3),
      borderColor: Colors.black,
      onPressed: () async => await verifyPasswordResetModel.sendPaswordResetEmail(context: context),
      onChanged: (value) => verifyPasswordResetModel.email = value,
    );
  }
}
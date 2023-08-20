// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/auth/account_model.dart';
import 'package:sonanceep_sns/views/auth/components/password_field_and_button_screen.dart';

class ReauthenticationPage extends ConsumerWidget {
  const ReauthenticationPage({
    Key? key,
    required this.accountModel,
    required this.firestoreUser,
  }) : super(key: key);

  final AccountModel accountModel;
  final FirestoreUser firestoreUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final TextEditingController textEditingController = TextEditingController(text: accountModel.password);
    final TextEditingController passwordEditingController = TextEditingController(text: accountModel.password);

    return PasswordFieldAndButtonScreen(
      appberTitle: reauthenticationPageTitle,
      buttonText: reauthenticateText,
      passwordEditingController: passwordEditingController,
      textEditingController: textEditingController,
      toggleObscureText: () => accountModel.toggleIsObscure(),
      shadowColor: Colors.green.withOpacity(0.3),
      buttonColor: Colors.orange.withOpacity(0.5),
      obscureText: accountModel.isObscure,
      onPressed: () async => await accountModel.reauthenticateWithCredention(context: context, firestoreUser: firestoreUser),
      onChanged: (value) => accountModel.password = value,
    );
  }
}
// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routs;
// models
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/auth/account_model.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final AccountModel accountModel = ref.watch(accountProvider);
    final firestoreUser = mainModel.firestoreUser;
    final l10n = returnL10n(context: context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(accountTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text(updatePasswordText),
            trailing: const Icon(Icons.arrow_forward_ios),
            // reauthenticationするページに飛ばす
            onTap: () {
              accountModel.reauthenticationState = ReauthenticationState.updatePassword;
              routs.toReauthenticationPage(context: context, accountModel: accountModel, firestoreUser: firestoreUser);
            }
          ),
          ListTile(
            // emailの更新が反映されるまで時間がかかる可能性がある
            title: Text(accountModel.currentUser!.email!),  // Text(updateEmailLagMsg(email: accountModel.currentUser!.email!)),  ラグのメッセージ
            trailing: const Icon(Icons.arrow_forward_ios),
            // reauthenticationするページに飛ばす
            onTap: () {
              accountModel.reauthenticationState = ReauthenticationState.updateEmail;
              routs.toReauthenticationPage(context: context, accountModel: accountModel, firestoreUser: firestoreUser);
            }
          ),
          ListTile(
            title: Text(l10n.deleteUser),
            trailing: const Icon(Icons.arrow_forward_ios),
            // reauthenticationするページに飛ばす
            onTap: () {
              accountModel.reauthenticationState = ReauthenticationState.deleteUser;
              routs.toReauthenticationPage(context: context, accountModel: accountModel, firestoreUser: firestoreUser);
            }
          ),
          ListTile(
            title: const Text(logoutText),
            onTap: () async => await accountModel.logout(context: context),
          )
        ],
      ),
    );
  }
}
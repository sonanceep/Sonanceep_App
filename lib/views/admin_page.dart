// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/models/admin_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AdminModel adminModel = ref.watch(adminProvider);
    final MuteUsersModel muteUsersModel = ref.watch(muteUsersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(adminTitle),),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RoundedButton(
                onPressed: () async => await adminModel.admin(firestoreUser: mainModel.firestoreUser),  //管理者権限を使用しない場合ここを変更
                widthRate: 0.85,
                color: Colors.blue,
                text: adminTitle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RoundedButton(
                onPressed: () async => await adminModel.adminAddSounds(firestoreUser: mainModel.firestoreUser),  //管理者権限を使用しない場合ここを変更
                widthRate: 0.85,
                color: Colors.purple,
                text: adminAddSoundsTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
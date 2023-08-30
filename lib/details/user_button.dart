// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';
import 'package:sonanceep_sns/models/main/passive_user_profile_model.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

class UserButton extends ConsumerWidget {
  const UserButton({
    Key? key,
    required this.mainModel,
    required this.passiveUser,
  }) : super(key: key);

  final MainModel mainModel;
  final FirestoreUser passiveUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final String passiveUid = passiveUser.uid;
    final PassiveUserProfileModel passiveUserProfileModel = ref.watch(passiveUserProfileProvider);
    final MessageModel messageModel = ref.watch(messageProvider);

    return mainModel.currentUserDoc.id == passiveUid ?   //自分か本人か、自分なら編集するためのボタンをリターン、違うならフォロー,アンフォローボタンをリターン
    RoundedButton(
      onPressed: () => routes.toEditProfilePage(context: context, mainModel: mainModel),
      widthRate: 0.85,
      color: Colors.purple,
      text: editProfileText,
    )
    : mainModel.followingUids.contains(passiveUid) ?
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1, // 横幅の半分のスペース
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedButton(
              onPressed: () async => await passiveUserProfileModel.unfollow(mainModel: mainModel, passiveUser: passiveUser),
              widthRate: 0.85,
              color: Colors.red,
              text: "アンフォロー",
            ),
          ),
        ),
        Expanded(
          flex: 1, // 横幅の半分のスペース
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedButton(
              onPressed: () => routes.toMessagePage(context: context, mainModel: mainModel, passiveUser: passiveUser),
              widthRate: 0.85,
              color: Colors.blueGrey,
              text: "メッセージ",
            ),
          ),
        ),
      ],
    ) 
    : Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedButton(
        onPressed: () async => await passiveUserProfileModel.follow(mainModel: mainModel, passiveUser: passiveUser),
        widthRate: 0.85,
        color: Colors.green,
        text: "フォロー",
      ),
    );
  }
}
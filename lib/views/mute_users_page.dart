// flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// components
import 'package:sonanceep_sns/views/refresh_screen.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';

class MuteUsersPage extends ConsumerWidget {
  const MuteUsersPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MuteUsersModel muteUsersModel = ref.watch(muteUsersProvider);
    final muteUserDocs = muteUsersModel.muteUserDocs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(muteUsersPageTitle),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () => print(mainModel.muteUids.length)),  //デバッグ方法
      body: muteUsersModel.showMuteUsers ? 
      RefreshScreen(
        onRefresh: () async => await muteUsersModel.onRefresh(mainModel: mainModel),
        onLoading: () async => await muteUsersModel.onLoading(),
        refreshController: muteUsersModel.refreshController,
        child: ListView.builder(
          itemCount: muteUserDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final muteUserDoc = muteUserDocs[index];
            final FirestoreUser muteFirestoreUser = FirestoreUser.fromJson(muteUserDoc.data()!);
            return ListTile(
              title: Text(muteFirestoreUser.userName),
              onTap: () => voids.showPopup(
                context: context,
                builder: (BuildContext innerContext) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        muteUsersModel.showMuteUserDialog(context: context, mainModel: mainModel, passiveUid: muteFirestoreUser.uid, docs: []);
                      },
                      child: const Text(muteUserText),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(innerContext),
                      child: const Text(backText),
                    ),
                  ]
                )
              ),
            );
          }
        ),
      ) : 
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              onPressed: () async => await muteUsersModel.getMuteUsers(mainModel: mainModel),
              widthRate: 0.85,
              color: Colors.blue,
              text: showMuteUsersText,
            ),
          )
        ],
      ),
    );
  }
}
// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/models/main/user_search_model.dart';
import 'package:sonanceep_sns/views/main/components/search_screen.dart';
// constants
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
// model
import 'package:sonanceep_sns/models/main/passive_user_profile_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class UserSearchScreen extends ConsumerWidget {
  const UserSearchScreen({
    Key? key,
    required this.mainModel,
    required this.passiveUserProfileModel,
  }) : super(key: key);

  final MainModel mainModel;
  final PassiveUserProfileModel passiveUserProfileModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final UserSearchModel userSearchModel = ref.watch(userSearchProvider);
    final userDocs = userSearchModel.userDocs;

    return SearchScreen(
      onQueryChanged: (text) async {
        userSearchModel.searchTerm = text;
        await userSearchModel.operation(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds);
      },
      child: ListView.builder(  // DocumentSnapShotを使用するときはListView.builder()を使用した方が後々良い
        itemCount: userDocs.length,
        itemBuilder: (
          (context, index) {
            // usersの配列から１個１個取得している
            final userDoc = userDocs[index];
            final FirestoreUser firestoreUser = FirestoreUser.fromJson(userDoc.data()!);

            return ListTile(
              title: Text(firestoreUser.userName),
              onTap: () async => await passiveUserProfileModel.onUserIconPressed(context: context, mainModel: mainModel, passiveUserDoc: userDoc,)
            );
          } 
        ),
      ),
    );
  }
}



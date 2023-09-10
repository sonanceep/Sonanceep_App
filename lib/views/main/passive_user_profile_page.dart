// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/colors.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// components
import 'package:sonanceep_sns/details/user_header.dart';
import 'package:sonanceep_sns/views/posts/components/post_card.dart';
import 'package:sonanceep_sns/details/reload_screen.dart';
import 'package:sonanceep_sns/views/refresh_screen.dart';
// domain
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
// models
import 'package:sonanceep_sns/models/main/passive_user_profile_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class PassiveUserProfilePage extends HookConsumerWidget {
  const PassiveUserProfilePage({
    Key? key,
    required this.passiveUserDoc,
    required this.mainModel,
  }) : super(key: key);

  final DocumentSnapshot<Map<String,dynamic>> passiveUserDoc;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // final RefreshController refreshController = RefreshController();
    final PassiveUserProfileModel passiveUserProfileModel = ref.watch(passiveUserProfileProvider);
    final FirestoreUser passiveUser = FirestoreUser.fromJson(passiveUserDoc.data()!);
    final postDocs = passiveUserProfileModel.postDocs;
    final muteUids = mainModel.muteUids;

    // useEffect(() {
    //   return refreshController.dispose;
    // }, []);
 
    return Scaffold(
      appBar: AppBar(
        title: const Text(profileTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: UserHeader(
                firestoreUser: passiveUser,
                mainModel: mainModel,
                onTap: () => passiveUserProfileModel.onMenuPressed(
                  context: context,
                  muteUids: muteUids,
                  mutePostIds: mainModel.mutePostIds,
                  passiveUserDoc: passiveUserDoc,
                ),
              ),
            ),
            const Divider(
              color: dividerColor,
              thickness: 4.0,
            ),
            //投稿
            postDocs.isEmpty ? 
            ReloadScreen(onReload: () async => await passiveUserProfileModel.onReload(passiveUserDoc: passiveUserDoc, muteUids: muteUids, mutePostIds: mainModel.mutePostIds,))
            : SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,  //画面の高さ * 0.5
              child: RefreshScreen(
                onRefresh: () async => passiveUserProfileModel.onRefresh(passiveUserDoc: passiveUserDoc, muteUids: muteUids, mutePostIds: mainModel.mutePostIds,),
                onLoading: () async => passiveUserProfileModel.onLoading(passiveUserDoc: passiveUserDoc, muteUids: muteUids, mutePostIds: mainModel.mutePostIds,),
                refreshController: passiveUserProfileModel.refreshController,
                child: ListView.builder(
                  itemCount: postDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final postDoc = postDocs[index];
                    final Post post = Post.fromJson(postDoc.data()!);
                    return PostCard(post: post, postDocs: postDocs, index: index, mainModel: mainModel);
                  },
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
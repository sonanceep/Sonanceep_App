// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
// components
import 'package:sonanceep_sns/details/user_header.dart';
import 'package:sonanceep_sns/details/post_card.dart';
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
            UserHeader(
              firestoreUser: passiveUser,
              mainModel: mainModel,
              onTap: () => passiveUserProfileModel.onMenuPressed(
                context: context,
                muteUids: muteUids,
                mutePostIds: mainModel.mutePostIds,
                passiveUserDoc: passiveUserDoc,
              ),
            ),
            postDocs.isEmpty ? 
            ReloadScreen(onReload: () async => passiveUserProfileModel.onReload(passiveUserDoc: passiveUserDoc, muteUids: muteUids, mutePostIds: mainModel.mutePostIds,)) :
            SizedBox(
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
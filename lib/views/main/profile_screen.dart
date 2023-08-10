// flutter
import 'package:flutter/cupertino.dart';
// packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// components
import 'package:sonanceep_sns/details/user_header.dart';
import 'package:sonanceep_sns/details/post_card.dart';
import 'package:sonanceep_sns/details/reload_screen.dart';
import 'package:sonanceep_sns/views/refresh_screen.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/main/profile_model.dart';
// domain
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';


class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    final ProfileModel profileModel = ref.watch(profileProvider);
    final FirestoreUser firestoreUser = mainModel.firestoreUser;
    final postDocs = profileModel.postDocs;
    final RefreshController refreshController = RefreshController();

    useEffect(() {
      return refreshController.dispose;
    }, []);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //プロフィール部分
          UserHeader(firestoreUser: firestoreUser, mainModel: mainModel, onTap: () => profileModel.onMenuPressed(context: context),),
          //自分の投稿
          postDocs.isEmpty ? 
          ReloadScreen(onReload: () async => profileModel.onReload()) :
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,  //画面の高さ * 0.6
            child: RefreshScreen(
              onRefresh: () async => profileModel.onRefresh(refreshController),
              onLoading: () async => profileModel.onLoading(refreshController),
              refreshController: refreshController,
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
    );
  }
}
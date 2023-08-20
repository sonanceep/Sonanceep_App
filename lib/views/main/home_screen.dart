// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/models/themes_model.dart';
// packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// components
import 'package:sonanceep_sns/details/sns_drawer.dart';
import 'package:sonanceep_sns/details/post_card.dart';
import 'package:sonanceep_sns/details/reload_screen.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
// model
import 'package:sonanceep_sns/models/main/home_model.dart';
import 'package:sonanceep_sns/models/create_post_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';
// domain
import 'package:sonanceep_sns/views/refresh_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    Key? key,
    required this.mainModel,
    required this.muteUserModel,
    required this.themeModel,
  }) : super(key: key);

  final MainModel mainModel;
  final MuteUsersModel muteUserModel;
  final ThemeModel themeModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final HomeModel homeModel = ref.watch(homeProvider);
    // final CreatePostModel createPostModel = ref.watch(createPostProvider);
    final postDocs = homeModel.postDocs;
    final RefreshController refreshController = RefreshController();

    useEffect(() {
      return refreshController.dispose;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle),),
      drawer: SNSDrawer(mainModel: mainModel, themeModel: themeModel,),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.new_label),
      //   onPressed: () => createPostModel.showPostFlashBar(context: context, mainModel: mainModel),
      // ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            postDocs.isEmpty ? 
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,  //画面の高さ * 0.8
              child: ReloadScreen(onReload: () async => await homeModel.onReload())
            ) :
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,  //画面の高さ * 0.8
              child: RefreshScreen(
                onRefresh: () async => homeModel.onRefresh(refreshController),
                onLoading: () async => homeModel.onLoading(refreshController),
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
      ),
    );
  }
}







// // flutter
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// // packages
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// // constants
// import 'package:sonanceep_sns/constants/strings.dart';
// import 'package:sonanceep_sns/constants/voids.dart' as voids;
// // components
// import 'package:sonanceep_sns/details/post_card.dart';
// import 'package:sonanceep_sns/details/reload_screen.dart';
// import 'package:sonanceep_sns/domain/post/post.dart';
// // model
// import 'package:sonanceep_sns/models/main/home_model.dart';
// import 'package:sonanceep_sns/models/comments_model.dart';
// import 'package:sonanceep_sns/models/create_post_model.dart';
// // domain
// import 'package:sonanceep_sns/models/main_model.dart';
// import 'package:sonanceep_sns/models/mute_posts_model.dart';
// import 'package:sonanceep_sns/models/mute_users_model.dart';
// import 'package:sonanceep_sns/models/posts_model.dart';
// import 'package:sonanceep_sns/views/refresh_screen.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// class HomeScreen extends HookConsumerWidget {
//   const HomeScreen({
//     Key? key,
//     required this.mainModel,
//     required this.muteUserModel,
//   }) : super(key: key);

//   final MainModel mainModel;
//   final MuteUsersModel muteUserModel;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     final HomeModel homeModel = ref.watch(homeProvider);
//     final PostsModel postsModel = ref.watch(postsProvider);
//     final CommentsModel commentsModel = ref.watch(commentsProvider);
//     final CreatePostModel createPostModel = ref.watch(createPostProvider);
//     final MuteUsersModel muteUsersModel = ref.watch(muteUsersProvider);
//     final MutePostsModel mutePostsModel = ref.watch(mutePostsProvider);
//     final postDocs = homeModel.postDocs;
//     final RefreshController refreshController = RefreshController();

    // useEffect(() {
    //   return refreshController.dispose;
    // }, []);

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.new_label),
//         onPressed: () => createPostModel.showPostFlashBar(context: context, mainModel: mainModel),
//       ),
//       body: postDocs.isEmpty ? 
//       ReloadScreen(onReload: () async => homeModel.onReload()) :
//       RefreshScreen(
//         onRefresh: () async => homeModel.onRefresh(refreshController),
//         onLoading: () async => homeModel.onLoading(refreshController),
//         refreshController: refreshController,
//         child: ListView.builder(
//           itemCount: postDocs.length,
//           itemBuilder: (BuildContext context, int index) {
//             final postDoc = postDocs[index];
//             final Post post = Post.fromJson(postDoc.data()!);
//             return PostCard(
//               onTap: () => voids.showPopup(  //ユーザーをミュートしたい
//                 context: context,
//                 builder: (BuildContext innerContext) => CupertinoActionSheet(
//                   actions: [
//                     CupertinoActionSheetAction(
//                       isDestructiveAction: true,
//                       onPressed: () {
//                         Navigator.pop(innerContext);
//                         muteUsersModel.showMuteUserDialog(context: context, mainModel: mainModel, passiveUid: post.uid, docs: commentsModel.commentDocs);
//                       },
//                       child: const Text(muteUserText),
//                     ),
//                     CupertinoActionSheetAction(
//                       isDestructiveAction: true,
//                       onPressed: () {
//                         Navigator.pop(innerContext);
//                         mutePostsModel.showMutePostDialog(context: context, mainModel: mainModel, postDoc: postDoc, postDocs: postDocs);
//                       },
//                       child: const Text(mutePostText),
//                     ),
//                     CupertinoActionSheetAction(
//                       onPressed: () => Navigator.pop(innerContext),
//                       child: const Text(backText),
//                     ),
//                   ]
//                 )
//               ),
//               post: post,
//               postDoc: postDoc,
//               mainModel: mainModel,
//               postsModel: postsModel,
//               commentsModel: commentsModel
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
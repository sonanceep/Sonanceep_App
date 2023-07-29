// flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// components
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/views/refresh_screen.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_comments_model.dart';

class MuteCommentsPage extends ConsumerWidget {
  const MuteCommentsPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final MuteCommentsModel muteCommentsModel = ref.watch(muteCommentsProvider);
    final muteCommentDocs = muteCommentsModel.muteCommentDocs;
  
    return Scaffold(
      appBar: AppBar(
        title: const Text(muteCommentsPageTitle),
      ),
      body: muteCommentsModel.showMuteComments ? 
      RefreshScreen(
        onRefresh: () async => await muteCommentsModel.onRefresh(mainModel: mainModel),
        onLoading: () async => await muteCommentsModel.onLoading(),
        refreshController: muteCommentsModel.refreshController,
        child: ListView.builder(
          itemCount: muteCommentDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final muteCommentDoc = muteCommentDocs[index];
            final Comment muteComment = Comment.fromJson(muteCommentDoc.data()!);
            return ListTile(
              leading: UserImage(length: 60, userImageURL: muteComment.userImageURL,),
              title: Text(muteComment.comment),
              onTap: () => voids.showPopup(
                context: context,
                builder: (BuildContext innerContext) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        muteCommentsModel.showUnMuteCommentDialog(context: context, mainModel: mainModel, commentDoc: muteCommentDoc, commentDocs: muteCommentDocs);
                      },
                      child: const Text(unMuteCommentText),
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
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              onPressed: () async => await muteCommentsModel.getMutePostComments(mainModel: mainModel),
              widthRate: 0.85,
              color: Colors.blue,
              text: showMuteCommentsText,
            ),
          )
        ],
      ),
    );
  }
}
// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
// components
import 'package:sonanceep_sns/details/reload_screen.dart';
import 'package:sonanceep_sns/models/mute_comments_model.dart';
import 'package:sonanceep_sns/views/refresh_screen.dart';
import 'package:sonanceep_sns/views/comments/components/comment_card.dart';
// domain
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/comments_model.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({
    Key? key,
    required this.post,
    required this.postDoc,
    required this.mainModel,
  }) : super(key: key);

  final Post post;
  final DocumentSnapshot<Map<String,dynamic>> postDoc;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final MuteUsersModel muteUsersModel = ref.watch(muteUsersProvider);
    final MuteCommentsModel muteCommentsModel = ref.watch(muteCommentsProvider);
    final commentDocs = commentsModel.commentDocs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(commentTitle),
      ),
      body: commentDocs.isEmpty ?
      ReloadScreen(onReload: () async => commentsModel.onReload(postDoc: postDoc)) : 
      RefreshScreen(
        onRefresh: () async => commentsModel.onRefresh(postDoc: postDoc),
        onLoading: () async => commentsModel.onLoading(postDoc: postDoc),
        refreshController: commentsModel.refreshController,
        child: ListView.builder(
          itemCount: commentDocs.length,
          itemBuilder: (BuildContext context, int index) {
            final commentDoc = commentDocs[index];
            final Comment comment = Comment.fromJson(commentDoc.data()!);
            return CommentCard(
              onTap: () => voids.showPopup(
                context: context,
                builder: (BuildContext innerContext) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        muteUsersModel.showMuteUserDialog(context: context, mainModel: mainModel, passiveUid: comment.uid, docs: commentsModel.commentDocs);
                      },
                      child: const Text(muteUserText),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        muteCommentsModel.showMuteCommentDialog(context: context, mainModel: mainModel, commentDoc: commentDoc, commentDocs: commentDocs);
                      },
                      child: const Text(muteCommentText),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(innerContext);
                        commentsModel.reportComment(context: context, comment: comment, commentDoc: commentDoc);
                      },
                      child: const Text(reportCommentText),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () => Navigator.pop(innerContext),
                      child: const Text(backText),
                    ),
                  ]
                )
              ),
              mainModel: mainModel,
              post: post,
              comment: comment,
              commentDoc: commentDoc,
              commentsModel: commentsModel
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.new_label,),
        onPressed: () => commentsModel.showCommentFlashBar(context: context, mainModel: mainModel, postDoc: postDoc),
      ),
    );
  }
}
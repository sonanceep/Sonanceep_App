// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/constants/bools.dart';
// constants
import 'package:sonanceep_sns/constants/routes.dart' as routes;
// components
import 'package:sonanceep_sns/details/card_container.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/views/comments/components/comment_like_button.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// domain
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
// model
import 'package:sonanceep_sns/models/comments_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    Key? key,
    required this.onTap,
    required this.mainModel,
    required this.post,
    required this.comment,
    required this.commentDoc,
    required this.commentsModel,
  }) : super(key: key);

  final void Function()? onTap;
  final MainModel mainModel;
  final Post post;
  final Comment comment;
  final DocumentSnapshot<Map<String,dynamic>> commentDoc;
  final CommentsModel commentsModel;

  @override
  Widget build(BuildContext context) {
    // mainModelのfirestoreUserは更新されている。 updateされた瞬間
    final FirestoreUser firestoreUser = mainModel.firestoreUser;
    final bool isMyComment = comment.uid == firestoreUser.uid;
    return isValidUser(muteUids: mainModel.muteUids, map: commentDoc.data()!) && isValidComment(muteUids:mainModel .muteUids, comment: comment) ? 
    CardContainer(
      onTap: onTap,
      borderColor: Colors.green,
      child: Column(
        children: [
          //アイコン
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              UserImage(
                length: 32.0,
                userImageURL: isMyComment ? firestoreUser.userImageURL : comment.userImageURL,
              ),
              Text(
                isMyComment ? firestoreUser.userName : comment.userName,
                style: const TextStyle(fontSize: 24.0),
                overflow: TextOverflow.ellipsis,  //長いコメントは...で省略してくれる
              ),
            ],
          ),
          //投稿内容
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(comment.comment, style: const TextStyle(fontSize: 24.0),),
              ],
            ),
          ),
          //いいね、コメント
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: const Icon(Icons.replay),
                onTap: () => routes.toRepliesPage(
                  context: context,
                  comment: comment,
                  commentDoc: commentDoc,
                  mainModel: mainModel
                ),
              ),
              CommentLikeButton(
                mainModel: mainModel,
                post: post,
                comment: comment,
                commentDoc: commentDoc,
                commentsModel: commentsModel
              ),
            ],
          ),
        ],
      ),
    ) : const SizedBox.shrink();
  }
}
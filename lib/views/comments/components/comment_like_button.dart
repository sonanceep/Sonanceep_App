// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/comments_model.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

class CommentLikeButton extends StatelessWidget {
  CommentLikeButton({
    Key? key,
    required this.mainModel,
    required this.post,
    required this.comment,
    required this.commentDoc,
    required this.commentsModel,
  }) : super(key: key);

  final MainModel mainModel;
  final Post post;
  final Comment comment;
  final DocumentSnapshot<Map<String,dynamic>> commentDoc;
  final CommentsModel commentsModel;

  @override
  Widget build(BuildContext context) {
    final int plusOneCount = comment.likeCount + 1;
    final bool isLike = mainModel.likeCommentIds.contains(comment.postCommentId);
    return
    Row(
      children: [
        Container(
          child: isLike ? 
          InkWell(
            child: const Icon(Icons.favorite, color:  Colors.red,),  //いいね配列にあれば
            onTap: () async => await commentsModel.unlike(comment: comment, mainModel: mainModel, post: post, commentDoc: commentDoc),
          ) : 
          InkWell(  //いいね配列になければ
            child: const Icon(Icons.favorite,),  //いいね配列にあれば
            onTap: () async => await commentsModel.like(comment: comment, mainModel: mainModel, post: post, commentDoc: commentDoc),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            isLike ? 
            plusOneCount.toString() : 
            comment.likeCount.toString(),
          ),
        ),
      ],
    );
  }
}
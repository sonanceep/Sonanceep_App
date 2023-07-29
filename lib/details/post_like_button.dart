// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';
// domain
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/models/posts_model.dart';

class PostLikeButton extends StatelessWidget {
  PostLikeButton({
    Key? key,
    required this.mainModel,
    required this.post,
    required this.postsModel,
    required this.postDoc,
  }) : super(key: key);

  final MainModel mainModel;
  final Post post;
  final PostsModel postsModel;
  final DocumentSnapshot<Map<String,dynamic>> postDoc;

  @override
  Widget build(BuildContext context) {
    final bool isLike = mainModel.likePostIds.contains(post.postId);
    final int plusOneCount = post.likeCount + 1;
    return Row(
      children: [
        Container(
          child: isLike ?
          InkWell(
            child: const Icon(Icons.favorite, color:  Colors.red,),  //いいね配列にあれば
            onTap: () async => await postsModel.unlike(
              post: post,
              postRef: postDoc.reference,
              mainModel: mainModel,
              postDoc: postDoc,
            ),
          )
          : InkWell(  //いいね配列になければ
            child: const Icon(Icons.favorite,),  //いいね配列にあれば
            onTap: () async => await postsModel.like(
              post: post,
              postRef: postDoc.reference,
              mainModel: mainModel,
              postDoc: postDoc,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            isLike ? 
            plusOneCount.toString() : 
            post.likeCount.toString(),
          ),
        ),
      ],
    );
  }
}
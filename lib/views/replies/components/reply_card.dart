// flutter
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/bools.dart';
// constants
import 'package:sonanceep_sns/constants/routes.dart' as routes;
// components
import 'package:sonanceep_sns/details/card_container.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/reply/reply.dart';
import 'package:sonanceep_sns/models/replies_model.dart';
// domain
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/views/replies/components/reply_like_button.dart';

class ReplyCard extends ConsumerWidget {
  ReplyCard({
    Key? key,
    required this.onTap,
    required this.comment,
    required this.reply,
    required this.replyDoc,
    required this.mainModel,
  }) : super(key: key);

  final void Function()? onTap;
  final Comment comment;
  final Reply reply;
  final DocumentSnapshot replyDoc;
  final MainModel mainModel;

  //リアルタイム取得
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RepliesModel repliesModel = ref.watch(repliesProvider);

    return isValidUser(muteUids: mainModel.muteUids, map: replyDoc.data() as Map<String,dynamic>) && isValidReply(muteReplyIds: mainModel.muteReplyIds, reply: reply) ? //正しいユーザーもしくは正しいリプライであれば多大しいカードを表示
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
                userImageURL: reply.userImageURL,
              ),
              Text(
                reply.userName,
                style: TextStyle(fontSize: 24.0),
                overflow: TextOverflow.ellipsis,  //長いコメントは...で省略してくれる
              ),
            ],
          ),
          //投稿内容
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  reply.reply,
                  style: TextStyle(fontSize: 24.0),
                  overflow: TextOverflow.ellipsis,  //長いコメントは...で省略してくれる
                ),
                Expanded(child: SizedBox()),  //空虚なウェジットを作成してスペースを作る
                ReplyLikeButton(
                  mainModel: mainModel,
                  comment: comment,
                  reply: reply,
                  replyDoc: replyDoc,
                  repliesModel: repliesModel
                ),
              ],
            ),
          ),

          //いいね、コメント
          // replyLikeButton(
          //   mainModel: mainModel,
          //   post: post,
          //   reply: reply,
          //   replyDoc: replyDoc,
          //   replysModel: replysModel
          // ),
        ],
      ),
    ) : const SizedBox.shrink();  // SizedBox()は何も表示しないことの印
  }
}
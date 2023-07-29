import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'like_reply_token.freezed.dart';
part 'like_reply_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class LikeReplyToken with _$LikeReplyToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory LikeReplyToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required dynamic postCommentReplyRef,
    required String postCommentReplyId,
    required String tokenId,
    required String tokenType,
  }) = _LikeReplyToken;
  factory LikeReplyToken.fromJson(Map<String,dynamic> json) => _$LikeReplyTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
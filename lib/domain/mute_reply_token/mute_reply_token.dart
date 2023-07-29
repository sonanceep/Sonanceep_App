import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'mute_reply_token.freezed.dart';
part 'mute_reply_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class MuteReplyToken with _$MuteReplyToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory MuteReplyToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyId,
    required dynamic postCommentReplyRef,
    required String tokenId,
    required String tokenType,
  }) = _MuteReplyToken;
  factory MuteReplyToken.fromJson(Map<String,dynamic> json) => _$MuteReplyTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
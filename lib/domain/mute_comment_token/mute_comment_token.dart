import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'mute_comment_token.freezed.dart';
part 'mute_comment_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class MuteCommentToken with _$MuteCommentToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory MuteCommentToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentId,
    required dynamic postCommentRef,
    required String tokenId,
    required String tokenType,
  }) = _MuteCommentToken;
  factory MuteCommentToken.fromJson(Map<String,dynamic> json) => _$MuteCommentTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
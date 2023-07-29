import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'like_comment_token.freezed.dart';
part 'like_comment_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class LikeCommentToken with _$LikeCommentToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory LikeCommentToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required dynamic postCommentRef,
    required String postCommentId,
    required String tokenId,
    required String tokenType,
  }) = _LikeCommentToken;
  factory LikeCommentToken.fromJson(Map<String,dynamic> json) => _$LikeCommentTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
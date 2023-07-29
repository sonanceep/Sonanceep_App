import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'like_post_token.freezed.dart';
part 'like_post_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class LikePostToken with _$LikePostToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory LikePostToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required dynamic postRef,
    required String postId,
    required String tokenId,
    required String tokenType,
  }) = _LikePostToken;
  factory LikePostToken.fromJson(Map<String,dynamic> json) => _$LikePostTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
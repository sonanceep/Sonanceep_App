import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'comment.freezed.dart';
part 'comment.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Comment with _$Comment {
  const factory Comment({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required String comment,
    required String commentLanguageCode,
    required double commentNegativeScore,
    required double commentPositiveScore,
    required String commentSentiment,
    required int likeCount,
    required dynamic postRef,
    required String postCommentId,
    required int postCommentReplyCount,
    required int reportCount,
    required int muteCount,
    required String userName,
    required String userNameLanguageCode,
    required double userNameNegativeScore,
    required double userNamePositiveScore,
    required String userNameSentiment,
    required String uid,
    required String userImageURL,
    required dynamic updatedAt,
  }) = _Comment;
  factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
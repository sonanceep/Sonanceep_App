import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'comment_like.freezed.dart';
part 'comment_like.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class CommentLike with _$CommentLike {
  const factory CommentLike({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentCreatorUid,
    required dynamic postCommentRef,
    required String postCommentId,
  }) = _CommentLike;
  factory CommentLike.fromJson(Map<String,dynamic> json) => _$CommentLikeFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
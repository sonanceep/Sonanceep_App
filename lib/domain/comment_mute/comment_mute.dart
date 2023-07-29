import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'comment_mute.freezed.dart';
part 'comment_mute.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class CommentMute with _$CommentMute {
  const factory CommentMute({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentId,
    required dynamic postCommentRef,
  }) = _CommentMute;
  factory CommentMute.fromJson(Map<String,dynamic> json) => _$CommentMuteFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
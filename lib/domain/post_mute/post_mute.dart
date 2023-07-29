import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post_mute.freezed.dart';
part 'post_mute.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class PostMute with _$PostMute {
  const factory PostMute({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postId,
    required dynamic postRef,
  }) = _PostMute;
  factory PostMute.fromJson(Map<String,dynamic> json) => _$PostMuteFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
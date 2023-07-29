import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post_like.freezed.dart';
part 'post_like.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class PostLike with _$PostLike {
  const factory PostLike({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required dynamic postRef,
    required String postId,
  }) = _PostLike;
  factory PostLike.fromJson(Map<String,dynamic> json) => _$PostLikeFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
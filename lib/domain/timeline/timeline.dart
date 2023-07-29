import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'timeline.freezed.dart';
part 'timeline.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Timeline with _$Timeline {
  const factory Timeline({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required bool isRead,  //フォロワーが投稿を読んだかどうか
    required String postCreatorUid,
    required String postId,
  }) = _Timeline;
  factory Timeline.fromJson(Map<String,dynamic> json) => _$TimelineFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
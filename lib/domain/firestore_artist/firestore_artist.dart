import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'firestore_artist.freezed.dart';
part 'firestore_artist.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class FirestoreArtist with _$FirestoreArtist {
  const factory FirestoreArtist({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required dynamic updatedAt,
    required Map<String,dynamic> searchToken,
    required int albumCount,
    required int songCount,
    required String artistName,
    required String artistId,
    required String artistImageURL,
    required String artistForm,
    required List<String> artistGenre,
    required String artistNationality,
    required int activityStartYear,
  }) = _FirestoreArtist;
  factory FirestoreArtist.fromJson(Map<String,dynamic> json) => _$FirestoreArtistFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
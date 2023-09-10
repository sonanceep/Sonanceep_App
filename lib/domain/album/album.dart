import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'album.freezed.dart';
part 'album.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Album with _$Album {
  // DBに保存する
  // createdAtやIdが必要
  // 自分がフォローしたことの印
  const factory Album({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required dynamic updatedAt,
    required String artistId,
    required Map<String,dynamic> searchToken,
    required String albumName,
    required String albumId,
    required List<String> albumSongs,
    required String albumImageURL,
    required dynamic releaseDate,
    required dynamic artistRef,
  }) = _Album;
  factory Album.fromJson(Map<String,dynamic> json) => _$AlbumFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}
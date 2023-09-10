// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Album _$AlbumFromJson(Map<String, dynamic> json) {
  return _Album.fromJson(json);
}

/// @nodoc
mixin _$Album {
// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt =>
      throw _privateConstructorUsedError; // dynamic型 なんでも許す
  dynamic get updatedAt => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  Map<String, dynamic> get searchToken => throw _privateConstructorUsedError;
  String get albumName => throw _privateConstructorUsedError;
  String get albumId => throw _privateConstructorUsedError;
  List<String> get albumSongs => throw _privateConstructorUsedError;
  String get albumImageURL => throw _privateConstructorUsedError;
  dynamic get releaseDate => throw _privateConstructorUsedError;
  dynamic get artistRef => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AlbumCopyWith<Album> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumCopyWith<$Res> {
  factory $AlbumCopyWith(Album value, $Res Function(Album) then) =
      _$AlbumCopyWithImpl<$Res, Album>;
  @useResult
  $Res call(
      {dynamic createdAt,
      dynamic updatedAt,
      String artistId,
      Map<String, dynamic> searchToken,
      String albumName,
      String albumId,
      List<String> albumSongs,
      String albumImageURL,
      dynamic releaseDate,
      dynamic artistRef});
}

/// @nodoc
class _$AlbumCopyWithImpl<$Res, $Val extends Album>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? artistId = null,
    Object? searchToken = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? albumSongs = null,
    Object? albumImageURL = null,
    Object? releaseDate = freezed,
    Object? artistRef = freezed,
  }) {
    return _then(_value.copyWith(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      searchToken: null == searchToken
          ? _value.searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      albumSongs: null == albumSongs
          ? _value.albumSongs
          : albumSongs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      albumImageURL: null == albumImageURL
          ? _value.albumImageURL
          : albumImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as dynamic,
      artistRef: freezed == artistRef
          ? _value.artistRef
          : artistRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$$_AlbumCopyWith(_$_Album value, $Res Function(_$_Album) then) =
      __$$_AlbumCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic createdAt,
      dynamic updatedAt,
      String artistId,
      Map<String, dynamic> searchToken,
      String albumName,
      String albumId,
      List<String> albumSongs,
      String albumImageURL,
      dynamic releaseDate,
      dynamic artistRef});
}

/// @nodoc
class __$$_AlbumCopyWithImpl<$Res> extends _$AlbumCopyWithImpl<$Res, _$_Album>
    implements _$$_AlbumCopyWith<$Res> {
  __$$_AlbumCopyWithImpl(_$_Album _value, $Res Function(_$_Album) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? artistId = null,
    Object? searchToken = null,
    Object? albumName = null,
    Object? albumId = null,
    Object? albumSongs = null,
    Object? albumImageURL = null,
    Object? releaseDate = freezed,
    Object? artistRef = freezed,
  }) {
    return _then(_$_Album(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      searchToken: null == searchToken
          ? _value._searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      albumName: null == albumName
          ? _value.albumName
          : albumName // ignore: cast_nullable_to_non_nullable
              as String,
      albumId: null == albumId
          ? _value.albumId
          : albumId // ignore: cast_nullable_to_non_nullable
              as String,
      albumSongs: null == albumSongs
          ? _value._albumSongs
          : albumSongs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      albumImageURL: null == albumImageURL
          ? _value.albumImageURL
          : albumImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as dynamic,
      artistRef: freezed == artistRef
          ? _value.artistRef
          : artistRef // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Album implements _Album {
  const _$_Album(
      {required this.createdAt,
      required this.updatedAt,
      required this.artistId,
      required final Map<String, dynamic> searchToken,
      required this.albumName,
      required this.albumId,
      required final List<String> albumSongs,
      required this.albumImageURL,
      required this.releaseDate,
      required this.artistRef})
      : _searchToken = searchToken,
        _albumSongs = albumSongs;

  factory _$_Album.fromJson(Map<String, dynamic> json) =>
      _$$_AlbumFromJson(json);

// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  @override
  final dynamic createdAt;
// dynamic型 なんでも許す
  @override
  final dynamic updatedAt;
  @override
  final String artistId;
  final Map<String, dynamic> _searchToken;
  @override
  Map<String, dynamic> get searchToken {
    if (_searchToken is EqualUnmodifiableMapView) return _searchToken;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_searchToken);
  }

  @override
  final String albumName;
  @override
  final String albumId;
  final List<String> _albumSongs;
  @override
  List<String> get albumSongs {
    if (_albumSongs is EqualUnmodifiableListView) return _albumSongs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albumSongs);
  }

  @override
  final String albumImageURL;
  @override
  final dynamic releaseDate;
  @override
  final dynamic artistRef;

  @override
  String toString() {
    return 'Album(createdAt: $createdAt, updatedAt: $updatedAt, artistId: $artistId, searchToken: $searchToken, albumName: $albumName, albumId: $albumId, albumSongs: $albumSongs, albumImageURL: $albumImageURL, releaseDate: $releaseDate, artistRef: $artistRef)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Album &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            const DeepCollectionEquality()
                .equals(other._searchToken, _searchToken) &&
            (identical(other.albumName, albumName) ||
                other.albumName == albumName) &&
            (identical(other.albumId, albumId) || other.albumId == albumId) &&
            const DeepCollectionEquality()
                .equals(other._albumSongs, _albumSongs) &&
            (identical(other.albumImageURL, albumImageURL) ||
                other.albumImageURL == albumImageURL) &&
            const DeepCollectionEquality()
                .equals(other.releaseDate, releaseDate) &&
            const DeepCollectionEquality().equals(other.artistRef, artistRef));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt),
      artistId,
      const DeepCollectionEquality().hash(_searchToken),
      albumName,
      albumId,
      const DeepCollectionEquality().hash(_albumSongs),
      albumImageURL,
      const DeepCollectionEquality().hash(releaseDate),
      const DeepCollectionEquality().hash(artistRef));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AlbumCopyWith<_$_Album> get copyWith =>
      __$$_AlbumCopyWithImpl<_$_Album>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AlbumToJson(
      this,
    );
  }
}

abstract class _Album implements Album {
  const factory _Album(
      {required final dynamic createdAt,
      required final dynamic updatedAt,
      required final String artistId,
      required final Map<String, dynamic> searchToken,
      required final String albumName,
      required final String albumId,
      required final List<String> albumSongs,
      required final String albumImageURL,
      required final dynamic releaseDate,
      required final dynamic artistRef}) = _$_Album;

  factory _Album.fromJson(Map<String, dynamic> json) = _$_Album.fromJson;

  @override // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt;
  @override // dynamic型 なんでも許す
  dynamic get updatedAt;
  @override
  String get artistId;
  @override
  Map<String, dynamic> get searchToken;
  @override
  String get albumName;
  @override
  String get albumId;
  @override
  List<String> get albumSongs;
  @override
  String get albumImageURL;
  @override
  dynamic get releaseDate;
  @override
  dynamic get artistRef;
  @override
  @JsonKey(ignore: true)
  _$$_AlbumCopyWith<_$_Album> get copyWith =>
      throw _privateConstructorUsedError;
}

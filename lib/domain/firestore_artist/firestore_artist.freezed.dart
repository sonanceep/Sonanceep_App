// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreArtist _$FirestoreArtistFromJson(Map<String, dynamic> json) {
  return _FirestoreArtist.fromJson(json);
}

/// @nodoc
mixin _$FirestoreArtist {
// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt =>
      throw _privateConstructorUsedError; // dynamic型 なんでも許す
  dynamic get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get searchToken => throw _privateConstructorUsedError;
  int get albumCount => throw _privateConstructorUsedError;
  int get songCount => throw _privateConstructorUsedError;
  String get artistName => throw _privateConstructorUsedError;
  String get artistId => throw _privateConstructorUsedError;
  String get artistImageURL => throw _privateConstructorUsedError;
  String get artistForm => throw _privateConstructorUsedError;
  List<String> get artistGenre => throw _privateConstructorUsedError;
  String get artistNationality => throw _privateConstructorUsedError;
  int get activityStartYear => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreArtistCopyWith<FirestoreArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreArtistCopyWith<$Res> {
  factory $FirestoreArtistCopyWith(
          FirestoreArtist value, $Res Function(FirestoreArtist) then) =
      _$FirestoreArtistCopyWithImpl<$Res, FirestoreArtist>;
  @useResult
  $Res call(
      {dynamic createdAt,
      dynamic updatedAt,
      Map<String, dynamic> searchToken,
      int albumCount,
      int songCount,
      String artistName,
      String artistId,
      String artistImageURL,
      String artistForm,
      List<String> artistGenre,
      String artistNationality,
      int activityStartYear});
}

/// @nodoc
class _$FirestoreArtistCopyWithImpl<$Res, $Val extends FirestoreArtist>
    implements $FirestoreArtistCopyWith<$Res> {
  _$FirestoreArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? searchToken = null,
    Object? albumCount = null,
    Object? songCount = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? artistImageURL = null,
    Object? artistForm = null,
    Object? artistGenre = null,
    Object? artistNationality = null,
    Object? activityStartYear = null,
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
      searchToken: null == searchToken
          ? _value.searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      albumCount: null == albumCount
          ? _value.albumCount
          : albumCount // ignore: cast_nullable_to_non_nullable
              as int,
      songCount: null == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      artistImageURL: null == artistImageURL
          ? _value.artistImageURL
          : artistImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      artistForm: null == artistForm
          ? _value.artistForm
          : artistForm // ignore: cast_nullable_to_non_nullable
              as String,
      artistGenre: null == artistGenre
          ? _value.artistGenre
          : artistGenre // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artistNationality: null == artistNationality
          ? _value.artistNationality
          : artistNationality // ignore: cast_nullable_to_non_nullable
              as String,
      activityStartYear: null == activityStartYear
          ? _value.activityStartYear
          : activityStartYear // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreArtistCopyWith<$Res>
    implements $FirestoreArtistCopyWith<$Res> {
  factory _$$_FirestoreArtistCopyWith(
          _$_FirestoreArtist value, $Res Function(_$_FirestoreArtist) then) =
      __$$_FirestoreArtistCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic createdAt,
      dynamic updatedAt,
      Map<String, dynamic> searchToken,
      int albumCount,
      int songCount,
      String artistName,
      String artistId,
      String artistImageURL,
      String artistForm,
      List<String> artistGenre,
      String artistNationality,
      int activityStartYear});
}

/// @nodoc
class __$$_FirestoreArtistCopyWithImpl<$Res>
    extends _$FirestoreArtistCopyWithImpl<$Res, _$_FirestoreArtist>
    implements _$$_FirestoreArtistCopyWith<$Res> {
  __$$_FirestoreArtistCopyWithImpl(
      _$_FirestoreArtist _value, $Res Function(_$_FirestoreArtist) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? searchToken = null,
    Object? albumCount = null,
    Object? songCount = null,
    Object? artistName = null,
    Object? artistId = null,
    Object? artistImageURL = null,
    Object? artistForm = null,
    Object? artistGenre = null,
    Object? artistNationality = null,
    Object? activityStartYear = null,
  }) {
    return _then(_$_FirestoreArtist(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      searchToken: null == searchToken
          ? _value._searchToken
          : searchToken // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      albumCount: null == albumCount
          ? _value.albumCount
          : albumCount // ignore: cast_nullable_to_non_nullable
              as int,
      songCount: null == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int,
      artistName: null == artistName
          ? _value.artistName
          : artistName // ignore: cast_nullable_to_non_nullable
              as String,
      artistId: null == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String,
      artistImageURL: null == artistImageURL
          ? _value.artistImageURL
          : artistImageURL // ignore: cast_nullable_to_non_nullable
              as String,
      artistForm: null == artistForm
          ? _value.artistForm
          : artistForm // ignore: cast_nullable_to_non_nullable
              as String,
      artistGenre: null == artistGenre
          ? _value._artistGenre
          : artistGenre // ignore: cast_nullable_to_non_nullable
              as List<String>,
      artistNationality: null == artistNationality
          ? _value.artistNationality
          : artistNationality // ignore: cast_nullable_to_non_nullable
              as String,
      activityStartYear: null == activityStartYear
          ? _value.activityStartYear
          : activityStartYear // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreArtist
    with DiagnosticableTreeMixin
    implements _FirestoreArtist {
  const _$_FirestoreArtist(
      {required this.createdAt,
      required this.updatedAt,
      required final Map<String, dynamic> searchToken,
      required this.albumCount,
      required this.songCount,
      required this.artistName,
      required this.artistId,
      required this.artistImageURL,
      required this.artistForm,
      required final List<String> artistGenre,
      required this.artistNationality,
      required this.activityStartYear})
      : _searchToken = searchToken,
        _artistGenre = artistGenre;

  factory _$_FirestoreArtist.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreArtistFromJson(json);

// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  @override
  final dynamic createdAt;
// dynamic型 なんでも許す
  @override
  final dynamic updatedAt;
  final Map<String, dynamic> _searchToken;
  @override
  Map<String, dynamic> get searchToken {
    if (_searchToken is EqualUnmodifiableMapView) return _searchToken;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_searchToken);
  }

  @override
  final int albumCount;
  @override
  final int songCount;
  @override
  final String artistName;
  @override
  final String artistId;
  @override
  final String artistImageURL;
  @override
  final String artistForm;
  final List<String> _artistGenre;
  @override
  List<String> get artistGenre {
    if (_artistGenre is EqualUnmodifiableListView) return _artistGenre;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artistGenre);
  }

  @override
  final String artistNationality;
  @override
  final int activityStartYear;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FirestoreArtist(createdAt: $createdAt, updatedAt: $updatedAt, searchToken: $searchToken, albumCount: $albumCount, songCount: $songCount, artistName: $artistName, artistId: $artistId, artistImageURL: $artistImageURL, artistForm: $artistForm, artistGenre: $artistGenre, artistNationality: $artistNationality, activityStartYear: $activityStartYear)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FirestoreArtist'))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('searchToken', searchToken))
      ..add(DiagnosticsProperty('albumCount', albumCount))
      ..add(DiagnosticsProperty('songCount', songCount))
      ..add(DiagnosticsProperty('artistName', artistName))
      ..add(DiagnosticsProperty('artistId', artistId))
      ..add(DiagnosticsProperty('artistImageURL', artistImageURL))
      ..add(DiagnosticsProperty('artistForm', artistForm))
      ..add(DiagnosticsProperty('artistGenre', artistGenre))
      ..add(DiagnosticsProperty('artistNationality', artistNationality))
      ..add(DiagnosticsProperty('activityStartYear', activityStartYear));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreArtist &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality().equals(other.updatedAt, updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._searchToken, _searchToken) &&
            (identical(other.albumCount, albumCount) ||
                other.albumCount == albumCount) &&
            (identical(other.songCount, songCount) ||
                other.songCount == songCount) &&
            (identical(other.artistName, artistName) ||
                other.artistName == artistName) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.artistImageURL, artistImageURL) ||
                other.artistImageURL == artistImageURL) &&
            (identical(other.artistForm, artistForm) ||
                other.artistForm == artistForm) &&
            const DeepCollectionEquality()
                .equals(other._artistGenre, _artistGenre) &&
            (identical(other.artistNationality, artistNationality) ||
                other.artistNationality == artistNationality) &&
            (identical(other.activityStartYear, activityStartYear) ||
                other.activityStartYear == activityStartYear));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(updatedAt),
      const DeepCollectionEquality().hash(_searchToken),
      albumCount,
      songCount,
      artistName,
      artistId,
      artistImageURL,
      artistForm,
      const DeepCollectionEquality().hash(_artistGenre),
      artistNationality,
      activityStartYear);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreArtistCopyWith<_$_FirestoreArtist> get copyWith =>
      __$$_FirestoreArtistCopyWithImpl<_$_FirestoreArtist>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreArtistToJson(
      this,
    );
  }
}

abstract class _FirestoreArtist implements FirestoreArtist {
  const factory _FirestoreArtist(
      {required final dynamic createdAt,
      required final dynamic updatedAt,
      required final Map<String, dynamic> searchToken,
      required final int albumCount,
      required final int songCount,
      required final String artistName,
      required final String artistId,
      required final String artistImageURL,
      required final String artistForm,
      required final List<String> artistGenre,
      required final String artistNationality,
      required final int activityStartYear}) = _$_FirestoreArtist;

  factory _FirestoreArtist.fromJson(Map<String, dynamic> json) =
      _$_FirestoreArtist.fromJson;

  @override // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt;
  @override // dynamic型 なんでも許す
  dynamic get updatedAt;
  @override
  Map<String, dynamic> get searchToken;
  @override
  int get albumCount;
  @override
  int get songCount;
  @override
  String get artistName;
  @override
  String get artistId;
  @override
  String get artistImageURL;
  @override
  String get artistForm;
  @override
  List<String> get artistGenre;
  @override
  String get artistNationality;
  @override
  int get activityStartYear;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreArtistCopyWith<_$_FirestoreArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

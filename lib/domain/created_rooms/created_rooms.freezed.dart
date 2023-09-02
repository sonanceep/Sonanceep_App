// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'created_rooms.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CreatedRooms _$CreatedRoomsFromJson(Map<String, dynamic> json) {
  return _CreatedRooms.fromJson(json);
}

/// @nodoc
mixin _$CreatedRooms {
// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt => throw _privateConstructorUsedError;
  String get talkUid => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get talkRoomId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatedRoomsCopyWith<CreatedRooms> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatedRoomsCopyWith<$Res> {
  factory $CreatedRoomsCopyWith(
          CreatedRooms value, $Res Function(CreatedRooms) then) =
      _$CreatedRoomsCopyWithImpl<$Res, CreatedRooms>;
  @useResult
  $Res call({dynamic createdAt, String talkUid, String uid, String talkRoomId});
}

/// @nodoc
class _$CreatedRoomsCopyWithImpl<$Res, $Val extends CreatedRooms>
    implements $CreatedRoomsCopyWith<$Res> {
  _$CreatedRoomsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? talkUid = null,
    Object? uid = null,
    Object? talkRoomId = null,
  }) {
    return _then(_value.copyWith(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      talkUid: null == talkUid
          ? _value.talkUid
          : talkUid // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      talkRoomId: null == talkRoomId
          ? _value.talkRoomId
          : talkRoomId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CreatedRoomsCopyWith<$Res>
    implements $CreatedRoomsCopyWith<$Res> {
  factory _$$_CreatedRoomsCopyWith(
          _$_CreatedRooms value, $Res Function(_$_CreatedRooms) then) =
      __$$_CreatedRoomsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic createdAt, String talkUid, String uid, String talkRoomId});
}

/// @nodoc
class __$$_CreatedRoomsCopyWithImpl<$Res>
    extends _$CreatedRoomsCopyWithImpl<$Res, _$_CreatedRooms>
    implements _$$_CreatedRoomsCopyWith<$Res> {
  __$$_CreatedRoomsCopyWithImpl(
      _$_CreatedRooms _value, $Res Function(_$_CreatedRooms) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? talkUid = null,
    Object? uid = null,
    Object? talkRoomId = null,
  }) {
    return _then(_$_CreatedRooms(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      talkUid: null == talkUid
          ? _value.talkUid
          : talkUid // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      talkRoomId: null == talkRoomId
          ? _value.talkRoomId
          : talkRoomId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreatedRooms with DiagnosticableTreeMixin implements _CreatedRooms {
  const _$_CreatedRooms(
      {required this.createdAt,
      required this.talkUid,
      required this.uid,
      required this.talkRoomId});

  factory _$_CreatedRooms.fromJson(Map<String, dynamic> json) =>
      _$$_CreatedRoomsFromJson(json);

// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  @override
  final dynamic createdAt;
  @override
  final String talkUid;
  @override
  final String uid;
  @override
  final String talkRoomId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CreatedRooms(createdAt: $createdAt, talkUid: $talkUid, uid: $uid, talkRoomId: $talkRoomId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CreatedRooms'))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('talkUid', talkUid))
      ..add(DiagnosticsProperty('uid', uid))
      ..add(DiagnosticsProperty('talkRoomId', talkRoomId));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreatedRooms &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            (identical(other.talkUid, talkUid) || other.talkUid == talkUid) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.talkRoomId, talkRoomId) ||
                other.talkRoomId == talkRoomId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(createdAt), talkUid, uid, talkRoomId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreatedRoomsCopyWith<_$_CreatedRooms> get copyWith =>
      __$$_CreatedRoomsCopyWithImpl<_$_CreatedRooms>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreatedRoomsToJson(
      this,
    );
  }
}

abstract class _CreatedRooms implements CreatedRooms {
  const factory _CreatedRooms(
      {required final dynamic createdAt,
      required final String talkUid,
      required final String uid,
      required final String talkRoomId}) = _$_CreatedRooms;

  factory _CreatedRooms.fromJson(Map<String, dynamic> json) =
      _$_CreatedRooms.fromJson;

  @override // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt;
  @override
  String get talkUid;
  @override
  String get uid;
  @override
  String get talkRoomId;
  @override
  @JsonKey(ignore: true)
  _$$_CreatedRoomsCopyWith<_$_CreatedRooms> get copyWith =>
      throw _privateConstructorUsedError;
}
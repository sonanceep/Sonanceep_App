// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'firestore_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreRoom _$FirestoreRoomFromJson(Map<String, dynamic> json) {
  return _FirestoreRoom.fromJson(json);
}

/// @nodoc
mixin _$FirestoreRoom {
// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt =>
      throw _privateConstructorUsedError; // dynamic型 なんでも許す
  List<String> get joinedUserIds => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreRoomCopyWith<FirestoreRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreRoomCopyWith<$Res> {
  factory $FirestoreRoomCopyWith(
          FirestoreRoom value, $Res Function(FirestoreRoom) then) =
      _$FirestoreRoomCopyWithImpl<$Res, FirestoreRoom>;
  @useResult
  $Res call(
      {dynamic createdAt,
      List<String> joinedUserIds,
      String roomId,
      String lastMessage});
}

/// @nodoc
class _$FirestoreRoomCopyWithImpl<$Res, $Val extends FirestoreRoom>
    implements $FirestoreRoomCopyWith<$Res> {
  _$FirestoreRoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? joinedUserIds = null,
    Object? roomId = null,
    Object? lastMessage = null,
  }) {
    return _then(_value.copyWith(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      joinedUserIds: null == joinedUserIds
          ? _value.joinedUserIds
          : joinedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreRoomCopyWith<$Res>
    implements $FirestoreRoomCopyWith<$Res> {
  factory _$$_FirestoreRoomCopyWith(
          _$_FirestoreRoom value, $Res Function(_$_FirestoreRoom) then) =
      __$$_FirestoreRoomCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic createdAt,
      List<String> joinedUserIds,
      String roomId,
      String lastMessage});
}

/// @nodoc
class __$$_FirestoreRoomCopyWithImpl<$Res>
    extends _$FirestoreRoomCopyWithImpl<$Res, _$_FirestoreRoom>
    implements _$$_FirestoreRoomCopyWith<$Res> {
  __$$_FirestoreRoomCopyWithImpl(
      _$_FirestoreRoom _value, $Res Function(_$_FirestoreRoom) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? joinedUserIds = null,
    Object? roomId = null,
    Object? lastMessage = null,
  }) {
    return _then(_$_FirestoreRoom(
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      joinedUserIds: null == joinedUserIds
          ? _value._joinedUserIds
          : joinedUserIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreRoom with DiagnosticableTreeMixin implements _FirestoreRoom {
  const _$_FirestoreRoom(
      {required this.createdAt,
      required final List<String> joinedUserIds,
      required this.roomId,
      required this.lastMessage})
      : _joinedUserIds = joinedUserIds;

  factory _$_FirestoreRoom.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreRoomFromJson(json);

// const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  @override
  final dynamic createdAt;
// dynamic型 なんでも許す
  final List<String> _joinedUserIds;
// dynamic型 なんでも許す
  @override
  List<String> get joinedUserIds {
    if (_joinedUserIds is EqualUnmodifiableListView) return _joinedUserIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_joinedUserIds);
  }

  @override
  final String roomId;
  @override
  final String lastMessage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FirestoreRoom(createdAt: $createdAt, joinedUserIds: $joinedUserIds, roomId: $roomId, lastMessage: $lastMessage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FirestoreRoom'))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('joinedUserIds', joinedUserIds))
      ..add(DiagnosticsProperty('roomId', roomId))
      ..add(DiagnosticsProperty('lastMessage', lastMessage));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreRoom &&
            const DeepCollectionEquality().equals(other.createdAt, createdAt) &&
            const DeepCollectionEquality()
                .equals(other._joinedUserIds, _joinedUserIds) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(createdAt),
      const DeepCollectionEquality().hash(_joinedUserIds),
      roomId,
      lastMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreRoomCopyWith<_$_FirestoreRoom> get copyWith =>
      __$$_FirestoreRoomCopyWithImpl<_$_FirestoreRoom>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreRoomToJson(
      this,
    );
  }
}

abstract class _FirestoreRoom implements FirestoreRoom {
  const factory _FirestoreRoom(
      {required final dynamic createdAt,
      required final List<String> joinedUserIds,
      required final String roomId,
      required final String lastMessage}) = _$_FirestoreRoom;

  factory _FirestoreRoom.fromJson(Map<String, dynamic> json) =
      _$_FirestoreRoom.fromJson;

  @override // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  dynamic get createdAt;
  @override // dynamic型 なんでも許す
  List<String> get joinedUserIds;
  @override
  String get roomId;
  @override
  String get lastMessage;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreRoomCopyWith<_$_FirestoreRoom> get copyWith =>
      throw _privateConstructorUsedError;
}

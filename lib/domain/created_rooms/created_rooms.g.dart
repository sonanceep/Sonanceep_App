// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_rooms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CreatedRooms _$$_CreatedRoomsFromJson(Map<String, dynamic> json) =>
    _$_CreatedRooms(
      createdAt: json['createdAt'],
      talkUid: json['talkUid'] as String,
      uid: json['uid'] as String,
      talkRoomId: json['talkRoomId'] as String,
    );

Map<String, dynamic> _$$_CreatedRoomsToJson(_$_CreatedRooms instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'talkUid': instance.talkUid,
      'uid': instance.uid,
      'talkRoomId': instance.talkRoomId,
    };

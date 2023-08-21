// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'created_rooms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CreatedRooms _$$_CreatedRoomsFromJson(Map<String, dynamic> json) =>
    _$_CreatedRooms(
      createdAt: json['createdAt'],
      talkUserId: json['talkUserId'] as String,
      roomId: json['roomId'] as String,
    );

Map<String, dynamic> _$$_CreatedRoomsToJson(_$_CreatedRooms instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'talkUserId': instance.talkUserId,
      'roomId': instance.roomId,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreRoom _$$_FirestoreRoomFromJson(Map<String, dynamic> json) =>
    _$_FirestoreRoom(
      createdAt: json['createdAt'],
      joinedUserIds: (json['joinedUserIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      roomId: json['roomId'] as String,
      lastMessage: json['lastMessage'] as String,
    );

Map<String, dynamic> _$$_FirestoreRoomToJson(_$_FirestoreRoom instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'joinedUserIds': instance.joinedUserIds,
      'roomId': instance.roomId,
      'lastMessage': instance.lastMessage,
    };

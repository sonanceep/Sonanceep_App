// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreRoom _$$_FirestoreRoomFromJson(Map<String, dynamic> json) =>
    _$_FirestoreRoom(
      createdAt: json['createdAt'],
      joinedUsers: (json['joinedUsers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      talkRoomId: json['talkRoomId'] as String,
      lastMessage: json['lastMessage'] as String,
      updateAt: json['updateAt'],
    );

Map<String, dynamic> _$$_FirestoreRoomToJson(_$_FirestoreRoom instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'joinedUsers': instance.joinedUsers,
      'talkRoomId': instance.talkRoomId,
      'lastMessage': instance.lastMessage,
      'updateAt': instance.updateAt,
    };

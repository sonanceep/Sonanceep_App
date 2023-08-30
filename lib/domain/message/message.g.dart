// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      createdAt: json['createdAt'],
      senderId: json['senderId'] as String,
      message: json['message'] as String,
      isRead: json['isRead'] as bool,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'senderId': instance.senderId,
      'message': instance.message,
      'isRead': instance.isRead,
    };

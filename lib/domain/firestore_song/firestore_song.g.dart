// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreSong _$$_FirestoreSongFromJson(Map<String, dynamic> json) =>
    _$_FirestoreSong(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      searchToken: json['searchToken'] as Map<String, dynamic>,
      artistId: json['artistId'] as String,
      albumType: json['albumType'] as String,
      songName: json['songName'] as String,
      songId: json['songId'] as String,
      songBpm: (json['songBpm'] as num).toDouble(),
      songKey: json['songKey'] as int,
      songGenre:
          (json['songGenre'] as List<dynamic>).map((e) => e as String).toList(),
      songAlbums: (json['songAlbums'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      songImageURL: (json['songImageURL'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      songDuration: json['songDuration'] as int,
      releaseDate: json['releaseDate'],
      artistRef: json['artistRef'],
    );

Map<String, dynamic> _$$_FirestoreSongToJson(_$_FirestoreSong instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'searchToken': instance.searchToken,
      'artistId': instance.artistId,
      'albumType': instance.albumType,
      'songName': instance.songName,
      'songId': instance.songId,
      'songBpm': instance.songBpm,
      'songKey': instance.songKey,
      'songGenre': instance.songGenre,
      'songAlbums': instance.songAlbums,
      'songImageURL': instance.songImageURL,
      'songDuration': instance.songDuration,
      'releaseDate': instance.releaseDate,
      'artistRef': instance.artistRef,
    };

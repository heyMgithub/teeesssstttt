// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      songName: json['song_name'] as String?,
      artist: json['artist'] as String?,
      songLink: json['song_link'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'song_name': instance.songName,
      'artist': instance.artist,
      'song_link': instance.songLink,
      'image': instance.image,
    };

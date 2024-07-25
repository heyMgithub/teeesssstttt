// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      adsManager: json['AdsManager'] == null
          ? null
          : AdManager.fromJson(json['AdsManager'] as Map<String, dynamic>),
      songs: (json['Songs'] as List<dynamic>?)
          ?.map((e) => Song.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'AdsManager': instance.adsManager,
      'Songs': instance.songs,
    };

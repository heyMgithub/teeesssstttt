// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repo _$RepoFromJson(Map<String, dynamic> json) => Repo(
      name: json['name'] as String,
      description: json['description'] as String,
      html_url: json['html_url'] as String,
    );

Map<String, dynamic> _$RepoToJson(Repo instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'html_url': instance.html_url,
    };

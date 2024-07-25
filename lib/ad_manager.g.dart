// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdManager _$AdManagerFromJson(Map<String, dynamic> json) => AdManager(
      adNetwork: json['adNetwork'] as String?,
      interstitialAdmob: json['interstitialAdmob'] as String?,
      bannerAdmob: json['bannerAdmob'] as String?,
      nativeAdmob: json['nativeAdmob'] as String?,
      interstitialFan: json['interstitialFan'] as String?,
      bannerFan: json['bannerFan'] as String?,
      nativeFan: json['nativeFan'] as String?,
    );

Map<String, dynamic> _$AdManagerToJson(AdManager instance) => <String, dynamic>{
      'adNetwork': instance.adNetwork,
      'interstitialAdmob': instance.interstitialAdmob,
      'bannerAdmob': instance.bannerAdmob,
      'nativeAdmob': instance.nativeAdmob,
      'interstitialFan': instance.interstitialFan,
      'bannerFan': instance.bannerFan,
      'nativeFan': instance.nativeFan,
    };

import 'package:json_annotation/json_annotation.dart';
import 'ad_manager.dart';
import 'song.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  @JsonKey(name: 'AdsManager')
  final AdManager? adsManager;
  @JsonKey(name: 'Songs')
  final List<Song>? songs;

  Data({
    this.adsManager,
    this.songs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

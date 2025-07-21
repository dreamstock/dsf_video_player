// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videos_entry_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaylistClusterImpl _$$PlaylistClusterImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaylistClusterImpl(
      selectedClipUuid: json['selectedClipUuid'] as String,
      payload: (json['payload'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) =>
                    VideosEntryPayload.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      playerUuid: json['playerUuid'] as String?,
    );

Map<String, dynamic> _$$PlaylistClusterImplToJson(
        _$PlaylistClusterImpl instance) =>
    <String, dynamic>{
      'selectedClipUuid': instance.selectedClipUuid,
      'payload': instance.payload,
      'playerUuid': instance.playerUuid,
    };

_$VideosEntryPayloadImpl _$$VideosEntryPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$VideosEntryPayloadImpl(
      title: json['title'] as String,
      description: json['description'] as String?,
      matchInfos: json['matchInfos'] == null
          ? null
          : MatchInfos.fromJson(json['matchInfos'] as Map<String, dynamic>),
      videoUrl: json['videoUrl'] as String,
      tumbnail: json['tumbnail'] as String?,
      offset: json['offset'] == null
          ? null
          : ClipOffset.fromJson(json['offset'] as Map<String, dynamic>),
      clipUuid: json['clipUuid'] as String,
      spotlight: json['spotlight'] == null
          ? null
          : Spotlight.fromJson(json['spotlight'] as Map<String, dynamic>),
      isWeakness: json['isWeakness'] as bool?,
    );

Map<String, dynamic> _$$VideosEntryPayloadImplToJson(
        _$VideosEntryPayloadImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'matchInfos': instance.matchInfos,
      'videoUrl': instance.videoUrl,
      'tumbnail': instance.tumbnail,
      'offset': instance.offset,
      'clipUuid': instance.clipUuid,
      'spotlight': instance.spotlight,
      'isWeakness': instance.isWeakness,
    };

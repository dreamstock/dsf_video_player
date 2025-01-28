import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:player_source_models/models/spreedsheet/clips/spotlight.dart';
import 'package:player_source_models/models/spreedsheet/clips/clip_offset.dart';
import 'package:video_generator/video_generator.dart';

part 'videos_entry_payload.freezed.dart';

typedef GroupName = String;

@freezed
abstract class PlaylistCluster with _$PlaylistCluster {
  const PlaylistCluster._();

  factory PlaylistCluster({
    required String selectedClipUuid,
    required Map<GroupName, List<VideosEntryPayload>> payload,
  }) = _PlaylistCluster;

  GroupName get selectedGroupName {
    for (final group in payload.entries) {
      if (group.value.any((element) => element.clipUuid == selectedClipUuid)) {
        return group.key;
      }
    }

    throw Exception('No clip with uuid $selectedClipUuid found in the payload');
  }

  VideosEntryPayload get current {
    for (final group in payload.values) {
      final index =
          group.indexWhere((element) => element.clipUuid == selectedClipUuid);
      if (index != -1) {
        return group[index];
      }
    }

    throw Exception('No clip with uuid $selectedClipUuid found in the payload');
  }

  VideosEntryPayload? get next {
    for (final groupEntry in payload.entries) {
      final groupName = groupEntry.key;
      final group = groupEntry.value;
      final index =
          group.indexWhere((element) => element.clipUuid == selectedClipUuid);
      if (index != -1) {
        if (index + 1 < group.length) {
          return group[index + 1];
        }
        final nextGroupIndex = payload.keys.toList().indexOf(groupName) + 1;
        if (nextGroupIndex < payload.keys.length) {
          final nextGroupName = payload.keys.elementAt(nextGroupIndex);
          if (payload[nextGroupName]?.isNotEmpty == true) {
            return payload[nextGroupName]!.first;
          }
        }
      }
    }

    return null;
  }

  VideosEntryPayload? get previous {
    for (final groupEntry in payload.entries) {
      final groupName = groupEntry.key;
      final group = groupEntry.value;
      final index =
          group.indexWhere((element) => element.clipUuid == selectedClipUuid);
      if (index != -1) {
        if (index - 1 >= 0) {
          return group[index - 1];
        }
        final previousGroupIndex = payload.keys.toList().indexOf(groupName) - 1;
        if (previousGroupIndex >= 0) {
          final previousGroupName = payload.keys.elementAt(previousGroupIndex);
          if (payload[previousGroupName]?.isNotEmpty == true) {
            return payload[previousGroupName]!.last;
          }
        }
      }
    }

    return null;
  }
}

@freezed
abstract class VideosEntryPayload with _$VideosEntryPayload {
  factory VideosEntryPayload({
    required String title,
    required String? description,
    required MatchInfos? matchInfos,
    required String videoUrl,
    required String? tumbnail,
    required ClipOffset? offset,
    required String clipUuid,
    required Spotlight spotlight,
  }) = _VideosEntryPayload;
}

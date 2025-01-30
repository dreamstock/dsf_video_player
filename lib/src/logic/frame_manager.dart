import 'dart:async';

import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FrameManager {
  FrameManager._();

  static Future<FrameManager> initialize({
    required PlaylistCluster initialData,
  }) async {
    final manager = FrameManager._();

    manager.player = Player();
    manager.videoController = VideoController(manager.player);
    await manager.player.setPlaylistMode(PlaylistMode.loop);
    manager.currentCluster = ValueNotifier(initialData);

    int index = -1;
    final List<Media> medias = [];
    for (final group in initialData.payload.entries) {
      for (final payload in group.value) {
        index++;
        medias.add(Media(
          payload.videoUrl,
          start: payload.offset?.start,
          end: payload.offset?.end,
        ));
        manager._idToIndexInPlaylist[payload.clipUuid] = index;
        manager._indexInPlaylistToId[index] = payload.clipUuid;
      }
    }

    final playable = Playlist(medias);

    await manager.player.open(playable);

    final List<StreamSubscription> subscriptions = [];
    subscriptions.addAll([
      // Set value notifier of new
      manager.player.stream.playlist.listen((event) {
        final selecteClipUuidIndex = manager._indexInPlaylistToId[event.index];
        if (selecteClipUuidIndex != null) {
          manager.currentCluster.value = initialData.copyWith(
            selectedClipUuid: selecteClipUuidIndex,
          );
        }
      }),
    ]);

    return manager;
  }

  late final VideoController videoController;
  late final Player player;
  late final ValueNotifier<PlaylistCluster> currentCluster;
  final Map<ClipUuid, IndexInPlaylist> _idToIndexInPlaylist = {};
  final Map<IndexInPlaylist, ClipUuid> _indexInPlaylistToId = {};
  final List<StreamSubscription> subscriptions = [];

  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    player.dispose();
    currentCluster.dispose();
  }

  Future<void> jumpToGroupWithName(String groupName) async {
    final group = currentCluster.value.payload[groupName];
    if (group != null) {
      final index =
          group.isEmpty ? null : _idToIndexInPlaylist[group.first.clipUuid];
      if (index != null) {
        await player.jump(index);
        currentCluster.value = currentCluster.value.copyWith(
          selectedClipUuid: group.first.clipUuid,
        );
      }
    }
  }

  Future<void> jumpToClipWithId(ClipUuid clipId) async {
    final index = _idToIndexInPlaylist[clipId];
    if (index != null) {
      await player.jump(index);
      currentCluster.value = currentCluster.value.copyWith(
        selectedClipUuid: clipId,
      );
    }
  }
}

typedef ClipUuid = String;
typedef IndexInPlaylist = int;

// class MappingStructure {
//   final List<Media> _playlist;
// }
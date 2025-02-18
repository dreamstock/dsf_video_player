import 'dart:async';

import 'package:dsf_video_player/src/core/mock_for_empty.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_source_models/models/spreedsheet/clips/spotlight.dart';

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

    manager.totalLenght = manager._idToIndexInPlaylist.length;

    final playable = Playlist(medias);
    final isMock = initialData.selectedClipUuid == mock.selectedClipUuid;
    await manager.player.open(playable, play: isMock == false);
    if (isMock == true) {
      await manager.player.pause();
    } else {
      manager.setListeners();
    }

    return manager;
  }

  void setListeners() {
    subscriptions.addAll([
      player.stream.position.listen(
        (Duration position) async {
          final spotPos = _spotlight?.time;
          if (spotPos == null) return;
          final spotPosLittleMore = spotPos + const Duration(seconds: 1);

          final pMil = position.inMilliseconds;

          if (didAlreadyDisplayFocusInThisRole &&
              pMil < spotPos.inMilliseconds) {
            didAlreadyDisplayFocusInThisRole = false;
          }

          if (pMil >= spotPos.inMilliseconds &&
              pMil <= spotPosLittleMore.inMilliseconds &&
              didAlreadyDisplayFocusInThisRole == false) {
            didAlreadyDisplayFocusInThisRole = true;
            isDisplayFocusTime.value = true;
          }
        },
      ),
      // Set value notifier of new
      player.stream.playlist.listen((event) {
        final selecteClipUuidIndex = _indexInPlaylistToId[event.index];
        if (selecteClipUuidIndex != null) {
          currentCluster.value = currentCluster.value.copyWith(
            selectedClipUuid: selecteClipUuidIndex,
          );
        }
      }),
    ]);
  }

  // If the focus is already displayed in this role, we don't need to display it again.
  // If player seek the video back, we need to display the focus again. So we will
  // reset this to false again.
  bool didAlreadyDisplayFocusInThisRole = false;
  final ValueNotifier<bool> isDisplayFocusTime = ValueNotifier<bool>(false);

  Spotlight? _spotlight;

  late final VideoController videoController;
  late final Player player;
  late final ValueNotifier<PlaylistCluster> currentCluster;
  late final int totalLenght;
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
        final newCluster = currentCluster.value.copyWith(
          selectedClipUuid: group.first.clipUuid,
        );
        currentCluster.value = newCluster;
        final curr = currentCluster.value.current;
        _spotlight = curr.spotlight;
        await player.jump(index);
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

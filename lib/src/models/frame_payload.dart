// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_source_models/models/spreedsheet/clips/spotlight.dart';

import 'package:dsf_video_player/src/models/videos_entry_payload.dart';

class FramePayloadController {
  FramePayloadController({
    required this.controller,
    required this.currentPayload,
  });

  factory FramePayloadController.initialize({
    required VideosEntryPayload payload,
  }) {
    final frame = FramePayloadController(
      controller: VideoController(Player()),
      currentPayload: payload,
    );

    frame.isDisplayFocusTime.addListener(frame._onDisplayUpdate);
    frame._positionSub = frame.positionListener;

    return frame;
  }

  final VideoController controller;
  Spotlight? get spotlight {
    return currentPayload.spotlight;
  }

  Duration get endDuration {
    return currentPayload.offset?.end ?? player.state.duration;
  }

  Duration get startDuration {
    return currentPayload.offset?.start ?? Duration.zero;
  }

  VideosEntryPayload currentPayload;

  // If the focus is already displayed in this role, we don't need to display it again.
  // If player seek the video back, we need to display the focus again. So we will
  // reset this to false again.
  bool didAlreadyDisplayFocusInThisRole = false;
  final ValueNotifier<bool> isDisplayFocusTime = ValueNotifier<bool>(false);

  final Debouncer debounder = Debouncer(
    timerDuration: const Duration(milliseconds: 1500),
  );

  late final StreamSubscription<Duration> _positionSub;

  void dispose() {
    player.dispose();
    _positionSub.cancel();
    isDisplayFocusTime.removeListener(_onDisplayUpdate);
    isDisplayFocusTime.dispose();
  }

  Player get player => controller.player;

  Future<void> load(VideosEntryPayload payload) async {
    controller.player.setVolume(0);
    currentPayload = payload;
    player.open(Media(payload.videoUrl));
    await controller.player.pause();
    await controller.player.seek(startDuration);
  }

  void _onDisplayUpdate() {
    if (isDisplayFocusTime.value) {
      player.pause();
      debounder.resetDebounce(() {
        isDisplayFocusTime.value = false;
        player.play();
      });
    }
  }

  StreamSubscription<Duration> get positionListener {
    return player.stream.position.listen(
      (Duration position) {
        final spotPos = spotlight?.time;
        if (spotPos == null) return;

        final pMil = position.inMilliseconds;

        final isDurrAboveMax = endDuration.inMilliseconds <= pMil;
        if (isDurrAboveMax) {
          player.pause();
          return;
        }

        if (didAlreadyDisplayFocusInThisRole && pMil < spotPos.inMilliseconds) {
          didAlreadyDisplayFocusInThisRole = false;
        }

        if (pMil >= spotPos.inMilliseconds &&
            didAlreadyDisplayFocusInThisRole == false) {
          didAlreadyDisplayFocusInThisRole = true;
          isDisplayFocusTime.value = true;
        }
      },
    );
  }
}

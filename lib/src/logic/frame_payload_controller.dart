// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_source_models/models/spreedsheet/clips/spotlight.dart';

class FramePayloadController {
  FramePayloadController._({
    required this.controller,
    required this.currentPayload,
  });

  factory FramePayloadController.initialize({
    required VideosEntryPayload? payload,
  }) {
    final frame = FramePayloadController._(
      controller: VideoController(Player()),
      currentPayload: ValueNotifier(payload),
    );

    frame.isDisplayFocusTime.addListener(frame._onDisplayUpdate);
    frame._positionSub = frame.positionListener;

    return frame;
  }

  final VideoController controller;
  Spotlight? get spotlight {
    return currentPayload.value?.spotlight;
  }

  Duration get endDuration {
    return currentPayload.value?.offset?.end ?? player.state.duration;
  }

  Duration get startDuration {
    return currentPayload.value?.offset?.start ?? Duration.zero;
  }

  String? get currentUuid {
    return currentPayload.value?.clipUuid;
  }

  final ValueNotifier<VideosEntryPayload?> currentPayload;

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
    currentPayload.dispose();
    _positionSub.cancel();
    isDisplayFocusTime.removeListener(_onDisplayUpdate);
    isDisplayFocusTime.dispose();
  }

  Player get player => controller.player;
  bool get isDone => currentPayload.value != null;

  Future<void> stop() async {
    await controller.player.pause();
  }

  Future<void> load(VideosEntryPayload payload) async {
    // controller.player.setVolume(0);
    await controller.player.pause();
    currentPayload.value = payload;
    player.open(Media(payload.videoUrl));
    await controller.player.seek(startDuration);
    await controller.player.pause();
  }

  Future<void> startWithNewState(PlayerState state) async {
    return startWithRawData(rate: state.rate, volume: state.volume);
  }

  Future<void> startWithRawData({
    required double volume,
    required double rate,
  }) async {
    await controller.player.play();
    final currState = controller.player.state;
    if (currState.volume != volume) {
      await controller.player.setVolume(volume);
    }
    if (currState.rate != rate) {
      await controller.player.setRate(rate);
    }
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

  void Function(String clipUuid)? onEndClip;

  StreamSubscription<Duration> get positionListener {
    return player.stream.position.listen(
      (Duration position) async {
        final pMil = position.inMilliseconds;

        final isDurrAboveMax = endDuration.inMilliseconds <= pMil;
        if (isDurrAboveMax) {
          await player.pause();
          if (currentUuid != null) onEndClip?.call(currentUuid!);
          return;
        }

        final spotPos = spotlight?.time;
        if (spotPos == null) return;

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

import 'package:dsf_video_player/src/core/mock_for_empty.dart';
import 'package:dsf_video_player/src/logic/frame_payload_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';

class SwitchFramesController {
  SwitchFramesController._({
    required this.payload,
    required this.frame1,
    required this.frame2,
  });

  factory SwitchFramesController.initialize({
    required PlaylistCluster payload,
  }) {
    final curr = payload.current;
    final next = payload.next;
    final frame1 = FramePayloadController.initialize(
      payload: curr,
    );
    final frame2 = FramePayloadController.initialize(
      payload: next,
    );

    final controller = SwitchFramesController._(
      payload: ValueNotifier(payload),
      frame1: frame1,
      frame2: frame2,
    );

    frame1.loadVideoData(curr).then((_) {
      controller.setListeners();

      // frame1.startWithRawData(frame2.player.state);
      frame1
          .startWithRawData(
        rate: 1.0,
        volume: 0.0,
        // rate: 100.0,
        // volume: 100.0,
      )
          .then((_) {
        if (next != null) frame2.loadVideoData(next);
      });
    });

    return controller;
  }
  // Only modify intern
  final ValueNotifier<PlaylistCluster> payload;

  final FramePayloadController frame1;
  final FramePayloadController frame2;

  void dispose() {
    payload.removeListener(setNewOnEnd);
    payload.dispose();
    frame1.dispose();
    frame2.dispose();
  }

  void setListeners() {
    if (kMockId == payload.value.selectedClipUuid) {
      frame1.player.pause();
      return;
    }

    payload.addListener(setNewOnEnd);

    void switchToNext(String clipUuid) {
      final next = payload.value.next;
      if (next != null) {
        payload.value = payload.value.copyWith(
          selectedClipUuid: next.clipUuid,
        );
      }
    }

    frame1.onEndClip = switchToNext;
    frame2.onEndClip = switchToNext;
  }

  void setNewOnEnd() async {
    final curr = payload.value.current;
    final next = payload.value.next;

    final isFrame1 = frame1.currentUuid == curr.clipUuid;
    // print(
    //     '(${frame2.currentUuid == curr.clipUuid || isFrame1} )isFrame1: $isFrame1 || isFrame2: ${frame2.currentUuid == curr.clipUuid}');
    if (isFrame1) {
      frame2.cleanListeners();
      frame1.startWithNewState(frame2.player.state);
      if (next != null) frame2.loadVideoData(next);
      return;
    }

    final isFrame2 = frame2.currentUuid == curr.clipUuid;
    if (isFrame2) {
      frame1.cleanListeners();
      frame2.startWithNewState(frame1.player.state);
      if (next != null) frame1.loadVideoData(next);
      return;
    }

    // If not found, load the first frame
    frame1.cleanListeners();
    frame2.cleanListeners();
    await Future.wait([frame1.stop(), frame2.stop()]);
    await frame1.loadVideoData(curr);
    await frame1.startWithRawData(
      rate: 1.0,
      volume: 0.0,
      // rate: 100.0,
      // volume: 100.0,
    );
    if (next != null) frame2.loadVideoData(next);
  }

  void selectGroup(GroupName name) {
    payload.value = payload.value.copyWith(
      selectedClipUuid: payload.value.payload[name]!.first.clipUuid,
    );
  }

  void selectClip(String videoUuid) {
    payload.value = payload.value.copyWith(
      selectedClipUuid: videoUuid,
    );
  }
}

enum CurrentlyPlaying {
  frame1,
  frame2,
}

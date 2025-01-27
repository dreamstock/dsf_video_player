import 'package:dsf_video_player/src/logic/frame_payload_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';

class SwitchFramesController {
  // Only modify intern
  late final ValueNotifier<PlaylistCluster> payload;

  // CurrentlyPlaying _currentlyPlaying = CurrentlyPlaying.frame1;
  late final FramePayloadController frame1;
  late final FramePayloadController frame2;

  void dispose() {}

  void setListeners() {
    payload.addListener(() async {
      final curr = payload.value.current;
      final next = payload.value.next;

      final isFrame1 = frame1.currentUuid == curr.clipUuid;
      if (isFrame1) {
        frame1.start(frame2.player.state.volume);
        if (next != null) frame2.load(next);
        return;
      }

      final isFrame2 = frame2.currentUuid == curr.clipUuid;
      if (isFrame2) {
        frame2.start(frame1.player.state.volume);
        if (next != null) frame1.load(next);
        return;
      }

      // If not found, load the first frame
      await frame1.stop();
      await frame2.stop();
      await frame1.load(curr);
      frame1.start(1.0);
      if (next != null) frame2.load(next);
    });

    // frame1.controller.player.stream.position.listen((event) {
    //   if (event >= frame1.endDuration) {
    //     // Pass to next and search itselfs
    //     final next = payload.value.next;
    //     if (next != null) {
    //       payload.value = payload.value.copyWith(selectedClipUuid: next.clipUuid);
    //     }

    //     frame1.player.pause();
    //     frame1.load(payload.value.current);
    //     final currentVolume = frame1.player.state.volume;
    //     frame2.start(currentVolume);
    //   }
    // });
  }
}

enum CurrentlyPlaying {
  frame1,
  frame2,
}

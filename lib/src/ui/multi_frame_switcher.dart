import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/ui/frame_video_player.dart';
import 'package:flutter/material.dart';

// When one video ends, stats other video
class MultiSwitchPlayer extends StatelessWidget {
  final SwitchFramesController multiFrameController;
  const MultiSwitchPlayer({
    super.key,
    required this.multiFrameController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: multiFrameController.payload,
      builder: (context, payload, _) {
        final String selectedClipUuid = payload.selectedClipUuid;

        final frame1Clipuuid =
            multiFrameController.frame1.currentPayload.value?.clipUuid;
        final frame2Clipuuid =
            multiFrameController.frame2.currentPayload.value?.clipUuid;

        return Stack(
          children: [
            SizedBox.expand(
              child: Opacity(
                opacity: selectedClipUuid == frame1Clipuuid ? 1.0 : 0.0,
                child: FrameVideoPlayerImpl(
                  frame: multiFrameController.frame1,
                ),
              ),
            ),
            SizedBox.expand(
              child: Opacity(
                opacity: selectedClipUuid == frame2Clipuuid ? 1.0 : 0.0,
                child: FrameVideoPlayerImpl(
                  frame: multiFrameController.frame2,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

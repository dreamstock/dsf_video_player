import 'package:dsf_video_player/src/logic/frame_payload_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/frame_video_player.dart';
import 'package:flutter/material.dart';

// When one video ends, stats other video
class MultiSwitchPlayer extends StatefulWidget {
  final ValueNotifier<PlaylistCluster> payload;
  final FramePayloadController frame1;
  final FramePayloadController frame2;
  const MultiSwitchPlayer({
    super.key,
    required this.payload,
    required this.frame1,
    required this.frame2,
  });

  @override
  State<MultiSwitchPlayer> createState() => _MultiSwitchPlayerState();
}

class _MultiSwitchPlayerState extends State<MultiSwitchPlayer> {
  late String currentSelectedUrl;

  @override
  void initState() {
    super.initState();
    currentSelectedUrl = widget.payload.value.selectedClipUuid;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.payload,
        builder: (context, payload, _) {
          final String selectedClipUuid = payload.selectedClipUuid;

          final frame1Clipuuid = widget.frame1.currentPayload.value?.clipUuid;
          final frame2Clipuuid = widget.frame2.currentPayload.value?.clipUuid;

          return Stack(
            children: [
              SizedBox.expand(
                child: Opacity(
                  opacity: selectedClipUuid == frame1Clipuuid ? 1.0 : 0.0,
                  child: FrameVideoPlayerImpl(
                    frame: widget.frame1,
                  ),
                ),
              ),
              SizedBox.expand(
                child: Opacity(
                  opacity: selectedClipUuid == frame2Clipuuid ? 1.0 : 0.0,
                  child: FrameVideoPlayerImpl(
                    frame: widget.frame2,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

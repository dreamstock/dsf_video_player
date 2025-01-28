import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/multi_frame_switcher.dart';
import 'package:dsf_video_player/src/ui/select_clip.dart';
import 'package:flutter/material.dart';

class DsfPlaylistPlayer extends StatefulWidget {
  final PlaylistCluster payload;

  const DsfPlaylistPlayer({
    super.key,
    required this.payload,
  });

  @override
  State<DsfPlaylistPlayer> createState() => _DsfPlaylistPlayerState();
}

// Will tween opacity between two players, the current playing one will be visible
// and the other will be loading in the background, with opacity 0.0.
class _DsfPlaylistPlayerState extends State<DsfPlaylistPlayer> {
  late final SwitchFramesController controller;
  @override
  void initState() {
    super.initState();
    if (widget.payload.payload.isEmpty) {
      controller = SwitchFramesController.initialize(
        payload: widget.payload,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payload.payload.isEmpty) {
      return const SizedBox();
    }
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: SelectClip(controller: controller),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxWidth * 9.0 / 16.0,
                child: MultiSwitchPlayer(
                  multiFrameController: controller,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

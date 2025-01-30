import 'dart:ui';

import 'package:dsf_video_player/src/core/mock_for_empty.dart';
import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/multi_frame_switcher.dart';
import 'package:dsf_video_player/src/ui/select_clip.dart';
import 'package:flutter/material.dart';

class DsfPlaylistPlayer extends StatefulWidget {
  final PlaylistCluster? payload;
  final Widget? dontHaveDataWidget;

  const DsfPlaylistPlayer({
    super.key,
    required this.payload,
    this.dontHaveDataWidget,
  });

  @override
  State<DsfPlaylistPlayer> createState() => _DsfPlaylistPlayerState();
}

// Will tween opacity between two players, the current playing one will be visible
// and the other will be loading in the background, with opacity 0.0.
class _DsfPlaylistPlayerState extends State<DsfPlaylistPlayer> {
  late final bool isMock;
  late final SwitchFramesController controller;
  @override
  void initState() {
    super.initState();
    final payload = widget.payload;
    if (payload != null && payload.payload.isNotEmpty) {
      isMock = false;
      controller = SwitchFramesController.initialize(
        payload: payload,
      );
    } else {
      isMock = true;
      controller = SwitchFramesController.initialize(
        payload: mock,
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
    if (!isMock) {
      return _VideoPageWidget(controller: controller);
    }

    return ImageFiltered(
      enabled: true,
      imageFilter: ImageFilter.blur(
        sigmaX: 8,
        sigmaY: 8,
        tileMode: TileMode.decal,
      ),
      child: IgnorePointer(
        ignoring: true,
        child: Stack(
          children: [
            SizedBox.expand(
              child: _VideoPageWidget(controller: controller),
            ),
            if (widget.dontHaveDataWidget != null) ...[
              SizedBox.expand(
                child: widget.dontHaveDataWidget!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VideoPageWidget extends StatelessWidget {
  const _VideoPageWidget({
    required this.controller,
  });

  final SwitchFramesController controller;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < 1050) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 630),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth * 9.0 / 16.0,
                    child: MultiSwitchPlayer(
                      multiFrameController: controller,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SelectClip(controller: controller),
          ),
        ],
      );
    }
    return Row(
      children: [
        const SizedBox(width: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SelectClip(controller: controller),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * 9.0 / 16.0,
                  child: MultiSwitchPlayer(
                    multiFrameController: controller,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

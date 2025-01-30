import 'dart:async';
import 'dart:ui';

import 'package:dsf_video_player/src/core/mock_for_empty.dart';
import 'package:dsf_video_player/src/logic/frame_manager.dart';
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
  final Completer<FrameManager> managerCompleter = Completer();
  late final bool isMock;
  @override
  void initState() {
    super.initState();

    final payload = widget.payload;
    if (payload != null && payload.payload.isNotEmpty) {
      managerCompleter.complete(FrameManager.initialize(
        initialData: payload,
      ));
      isMock = false;
    } else {
      managerCompleter.complete(FrameManager.initialize(
        initialData: mock,
      ));
      isMock = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: managerCompleter.future,
      builder: (context, snapshot) {
        final manager = snapshot.data;
        if (manager == null) {
          return const SizedBox();
        }

        if (!isMock) {
          return _VideoPageWidget(manager: manager);
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
                  child: _VideoPageWidget(manager: manager),
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
      },
    );
  }
}

class _VideoPageWidget extends StatefulWidget {
  const _VideoPageWidget({
    required this.manager,
  });

  final FrameManager manager;

  @override
  State<_VideoPageWidget> createState() => _VideoPageWidgetState();
}

class _VideoPageWidgetState extends State<_VideoPageWidget> {
  @override
  void dispose() {
    widget.manager.dispose();
    super.dispose();
  }

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
                    child: FramePlayer(
                      manager: widget.manager,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SelectClip(manager: widget.manager),
          ),
        ],
      );
    }
    return Row(
      children: [
        const SizedBox(width: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SelectClip(manager: widget.manager),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * 9.0 / 16.0,
                  child: FramePlayer(
                    manager: widget.manager,
                  ),
                  // child: MultiSwitchPlayer(
                  //   multiFrameController: controller,
                  // ),
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

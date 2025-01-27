import 'package:dsf_video_player/src/models/frame_payload.dart';
import 'package:dsf_video_player/src/ui/video_player/loading_buffer_component.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/material_desktop.dart';

class FrameVideoPlayer extends StatelessWidget {
  final FramePayloadController frame;
  const FrameVideoPlayer({
    super.key,
    required this.frame,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialDesktopVideoControlsTheme(
      normal: const MaterialDesktopVideoControlsThemeData(
        toggleFullscreenOnDoublePress: true,
        seekBarHoverHeight: 12,
        seekBarHeight: 8,
        seekBarMargin: EdgeInsets.zero,
        buttonBarHeight: 86,
        seekBarThumbColor: Colors.orange,
        seekBarThumbSize: 18,
        displaySeekBar: false,
        seekBarContainerHeight: 8,
      ),
      fullscreen: const MaterialDesktopVideoControlsThemeData(),
      child: Video(
        controller: frame.controller,
        fill: Colors.transparent,
        controls: (state) {
          return FutureBuilder(
            future: state.widget.controller.waitUntilFirstFrameRendered,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingBufferComponent();
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      const Spacer(),
                      Consumer(builder: (context, ref, child) {
                        final clipOffset =
                            ref.watch(widget.currentClipOffsetProvider);

                        return DSFSeekBar(
                          key: UniqueKey(),
                          start: clipOffset?.start ?? Duration.zero,
                          end: clipOffset?.end ?? player.state.duration,
                        );
                      }),
                      ColoredBox(
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            StreamBuilder(
                              stream: state
                                  .widget.controller.player.stream.position,
                              builder: (context, snapshot) {
                                final position = snapshot.data;

                                if (position == null ||
                                    position < endDuration) {
                                  return Consumer(
                                      builder: (context, ref, child) {
                                    final clipOffset = ref.watch(
                                        widget.currentClipOffsetProvider);

                                    return CustomDSFPlayOrPauseButton(
                                      player: player,
                                      startDuration:
                                          clipOffset?.start ?? Duration.zero,
                                      maxDuration: clipOffset?.end ??
                                          player.state.duration,
                                    );
                                  });
                                }

                                return IconButton(
                                  onPressed: () {
                                    player.seek(startDuration);
                                  },
                                  icon: const Icon(
                                    Icons.replay,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            const MaterialDesktopSkipNextButton(),
                            const MaterialDesktopVolumeButton(),
                            Consumer(builder: (context, ref, child) {
                              final clipOffset =
                                  ref.watch(widget.currentClipOffsetProvider);

                              return CustomDSFPositionIndicator(
                                key: UniqueKey(),
                                start: clipOffset?.start ?? Duration.zero,
                                end: clipOffset?.end ?? player.state.duration,
                              );
                            }),
                            const SizedBox(width: 12),
                            const Spacer(),
                            const SizedBox(width: 8),
                            const MaterialDesktopFullscreenButton(),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IgnorePointer(
                    child: Consumer(builder: (context, ref, child) {
                      final spotlight = ref.watch(widget.spotlightProvider);
                      if (spotlight == null) {
                        return const SizedBox();
                      }

                      return LayoutBuilder(builder: (context, constraints) {
                        return ValueListenableBuilder(
                          valueListenable: isDisplayFocusTime,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value ? 1 : 0,
                              child: SpotlightWidget(
                                key: UniqueKey(),
                                spotlight: spotlight,
                                constraints: constraints,
                              ),
                            );
                          },
                        );
                      });
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

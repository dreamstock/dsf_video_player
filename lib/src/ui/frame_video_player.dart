import 'package:dsf_video_player/src/logic/frame_payload_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_material_bar.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_position_indicator.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_play_pause_video.dart';
import 'package:dsf_video_player/src/ui/video_player_components/loading_buffer_component.dart';
import 'package:dsf_video_player/src/ui/video_player_components/spotlight_widget.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

class FrameVideoPlayerImpl extends StatelessWidget {
  final FramePayloadController frame;
  const FrameVideoPlayerImpl({
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
                      ValueListenableBuilder<VideosEntryPayload?>(
                          valueListenable: frame.currentPayload,
                          builder: (context, payload, child) {
                            final clipOffset = payload?.offset;

                            return DSFSeekBar(
                              key: UniqueKey(),
                              start: clipOffset?.start ?? Duration.zero,
                              end: clipOffset?.end ??
                                  frame.player.state.duration,
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
                                    position < frame.endDuration) {
                                  return ValueListenableBuilder<
                                          VideosEntryPayload?>(
                                      valueListenable: frame.currentPayload,
                                      builder: (context, payload, child) {
                                        final clipOffset = payload?.offset;

                                        return CustomDSFPlayOrPauseButton(
                                          player: frame.player,
                                          startDuration: clipOffset?.start ??
                                              Duration.zero,
                                          maxDuration: clipOffset?.end ??
                                              frame.player.state.duration,
                                        );
                                      });
                                }

                                return IconButton(
                                  onPressed: () {
                                    frame.player.seek(frame.startDuration);
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
                            ValueListenableBuilder<VideosEntryPayload?>(
                              valueListenable: frame.currentPayload,
                              builder: (context, payload, child) {
                                final clipOffset = payload?.offset;

                                return CustomDSFPositionIndicator(
                                  key: UniqueKey(),
                                  start: clipOffset?.start ?? Duration.zero,
                                  end: clipOffset?.end ??
                                      frame.player.state.duration,
                                );
                              },
                            ),
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
                    child: ValueListenableBuilder<VideosEntryPayload?>(
                      valueListenable: frame.currentPayload,
                      builder: (context, payload, child) {
                        final spotlight = payload?.spotlight;
                        if (spotlight == null) {
                          return const SizedBox();
                        }

                        return LayoutBuilder(builder: (context, constraints) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: frame.isDisplayFocusTime,
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
                      },
                    ),
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

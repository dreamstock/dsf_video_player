import 'package:dsf_video_player/src/logic/frame_manager.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_material_bar.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_position_indicator.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_play_pause_video.dart';
import 'package:dsf_video_player/src/ui/video_player_components/loading_buffer_component.dart';
import 'package:dsf_video_player/src/ui/video_player_components/select_rate.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_source_models/models/spreedsheet/clips/clip_offset.dart';

class FramePlayer extends StatelessWidget {
  final FrameManager manager;
  const FramePlayer({
    super.key,
    required this.manager,
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
        controller: manager.videoController,
        fill: Colors.transparent,
        controls: (state) {
          return FutureBuilder(
            future: state.widget.controller.waitUntilFirstFrameRendered,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingBufferComponent();
              }

              return ValueListenableBuilder<PlaylistCluster>(
                  valueListenable: manager.currentCluster,
                  builder: (context, cluster, child) {
                    final payload = cluster.current;

                    return Stack(
                      children: [
                        Column(
                          children: [
                            const Spacer(),
                            Builder(
                              builder: (context) {
                                final clipOffset = payload.offset;

                                return DSFSeekBar(
                                  key: UniqueKey(),
                                  start: clipOffset?.start ?? Duration.zero,
                                  end: clipOffset?.end ??
                                      manager.player.state.duration,
                                );
                              },
                            ),
                            ColoredBox(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  StreamBuilder(
                                    stream: state.widget.controller.player
                                        .stream.position,
                                    builder: (context, snapshot) {
                                      final ClipOffset? clipOffset =
                                          payload.offset;
                                      return CustomDSFPlayOrPauseButton(
                                        player: manager.player,
                                        startDuration:
                                            clipOffset?.start ?? Duration.zero,
                                        maxDuration: clipOffset?.end ??
                                            manager.player.state.duration,
                                      );
                                    },
                                  ),
                                  const MaterialDesktopVolumeButton(),
                                  if (!(MediaQuery.sizeOf(context).width <
                                      1050)) ...[
                                    SelectRate(
                                        controller: manager.videoController),
                                    const SizedBox(width: 12),
                                    Builder(
                                      builder: (context) {
                                        final clipOffset = payload.offset;

                                        return CustomDSFPositionIndicator(
                                          key: UniqueKey(),
                                          start: clipOffset?.start ??
                                              Duration.zero,
                                          end: clipOffset?.end ??
                                              manager.player.state.duration,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                  const Spacer(),
                                  const SizedBox(width: 8),
                                  const MaterialDesktopFullscreenButton(),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // IgnorePointer(
                        //   child: Builder(
                        //     builder: (context) {
                        //       final spotlight = payload.spotlight;
                        //       if (spotlight == null) {
                        //         return const SizedBox();
                        //       }

                        //       return LayoutBuilder(
                        //           builder: (context, constraints) {
                        //         return ValueListenableBuilder<bool>(
                        //           valueListenable: frame.isDisplayFocusTime,
                        //           builder: (context, value, child) {
                        //             return Opacity(
                        //               opacity: value ? 1 : 0,
                        //               child: SpotlightWidget(
                        //                 key: UniqueKey(),
                        //                 spotlight: spotlight,
                        //                 constraints: constraints,
                        //               ),
                        //             );
                        //           },
                        //         );
                        //       },);
                        //     },
                        //   ),
                        // ),
                      ],
                    );
                  });
            },
          );
        },
      ),
    );
  }
}

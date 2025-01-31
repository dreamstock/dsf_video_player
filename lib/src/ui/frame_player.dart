import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:dsf_video_player/src/logic/frame_manager.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_material_bar.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_dsf_position_indicator.dart';
import 'package:dsf_video_player/src/ui/video_player_components/custom_play_pause_video.dart';
import 'package:dsf_video_player/src/ui/video_player_components/loading_buffer_component.dart';
import 'package:dsf_video_player/src/ui/video_player_components/select_rate.dart';
import 'package:dsf_video_player/src/ui/video_player_components/spotlight_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:player_source_models/models/spreedsheet/clips/clip_offset.dart';

class FramePlayer extends StatefulWidget {
  final FrameManager manager;
  const FramePlayer({
    super.key,
    required this.manager,
  });

  @override
  State<FramePlayer> createState() => _FramePlayerState();
}

class _FramePlayerState extends State<FramePlayer> {
  final ValueNotifier<bool> isFocused = ValueNotifier(false);

  final Debouncer debouncer = Debouncer(
    timerDuration: const Duration(milliseconds: 1400),
  );

  @override
  void dispose() {
    isFocused.dispose();
    debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.sizeOf(context).width < 1050;
    return MaterialDesktopVideoControlsTheme(
      normal: MaterialDesktopVideoControlsThemeData(
        toggleFullscreenOnDoublePress: true,
        seekBarHoverHeight: 12,
        seekBarHeight: 8,
        seekBarMargin: EdgeInsets.zero,
        buttonBarHeight: 86,
        seekBarPositionColor: Theme.of(context).colorScheme.primary,
        seekBarThumbSize: 18,
        displaySeekBar: false,
        seekBarContainerHeight: 8,
      ),
      fullscreen: MaterialDesktopVideoControlsThemeData(
        toggleFullscreenOnDoublePress: true,
        seekBarHoverHeight: 12,
        seekBarHeight: 8,
        seekBarMargin: EdgeInsets.zero,
        buttonBarHeight: 86,
        seekBarPositionColor: Theme.of(context).colorScheme.primary,
        seekBarThumbSize: 18,
        displaySeekBar: false,
        seekBarContainerHeight: 8,
      ),
      child: Video(
        controller: widget.manager.videoController,
        fill: Colors.transparent,
        controls: (state) {
          return VideoControllers(
            manager: widget.manager,
            isFocused: isFocused,
            debouncer: debouncer,
            isSmall: isSmall,
          );
        },
      ),
    );
  }
}

class VideoControllers extends StatefulWidget {
  const VideoControllers({
    super.key,
    required this.manager,
    required this.isFocused,
    required this.debouncer,
    required this.isSmall,
  });
  final FrameManager manager;
  final ValueNotifier<bool> isFocused;
  final Debouncer debouncer;
  final bool isSmall;

  @override
  State<VideoControllers> createState() => _VideoControllersState();
}

class _VideoControllersState extends State<VideoControllers> {
  final ValueNotifier<bool> shouldFullScreen = ValueNotifier(false);

  @override
  void initState() {
    shouldFullScreen.addListener(setFullScreen);
    super.initState();
  }

  @override
  void dispose() {
    shouldFullScreen.removeListener(setFullScreen);
    shouldFullScreen.dispose();
    super.dispose();
  }

  void setFullScreen() {
    toggleFullscreen(context);
  }

  void onEnter(PointerEnterEvent event) {
    widget.isFocused.value = true;
    widget.debouncer.resetDebounce(() => widget.isFocused.value = false);
  }

  void onHover(PointerHoverEvent event) {
    widget.isFocused.value = true;
    widget.debouncer.resetDebounce(() => widget.isFocused.value = false);
  }

  void onExit(PointerExitEvent event) => widget.isFocused.value = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.manager.videoController.waitUntilFirstFrameRendered,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingBufferComponent();
        }

        return MouseRegion(
          onEnter: onEnter,
          onHover: onHover,
          onExit: onExit,
          child: ValueListenableBuilder(
            valueListenable: widget.isFocused,
            builder: (context, val, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: val ? 1 : 0,
                child: child,
              );
            },
            child: ValueListenableBuilder<PlaylistCluster>(
              valueListenable: widget.manager.currentCluster,
              builder: (context, cluster, child) {
                final payload = cluster.current;

                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Builder(builder: (context) {
                            return InkWell(
                              onTap: () async {
                                await widget.manager.player.playOrPause();
                              },
                              onDoubleTap: () async {
                                shouldFullScreen.value =
                                    !shouldFullScreen.value;
                              },
                              child: const SizedBox.expand(),
                            );
                          }),
                        ),
                        Builder(
                          builder: (context) {
                            final clipOffset = payload.offset;

                            return DSFSeekBar(
                              key: UniqueKey(),
                              start: clipOffset?.start ?? Duration.zero,
                              end: clipOffset?.end ??
                                  widget.manager.player.state.duration,
                            );
                          },
                        ),
                        ColoredBox(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              StreamBuilder(
                                stream: widget.manager.player.stream.position,
                                builder: (context, snapshot) {
                                  final ClipOffset? clipOffset = payload.offset;
                                  return CustomDSFPlayOrPauseButton(
                                    player: widget.manager.player,
                                    startDuration:
                                        clipOffset?.start ?? Duration.zero,
                                    maxDuration: clipOffset?.end ??
                                        widget.manager.player.state.duration,
                                  );
                                },
                              ),
                              const MaterialDesktopVolumeButton(),
                              if (!widget.isSmall) ...[
                                if (widget.manager.totalLenght > 1) ...[
                                  const SizedBox(width: 8),
                                  const MaterialDesktopSkipPreviousButton(),
                                  const MaterialDesktopSkipNextButton(),
                                  const SizedBox(width: 8),
                                ],
                                SelectRate(
                                  controller: widget.manager.videoController,
                                  onEnter: onEnter,
                                  onHover: onHover,
                                  onExit: onExit,
                                ),
                                const SizedBox(width: 12),
                                Builder(
                                  builder: (context) {
                                    final clipOffset = payload.offset;

                                    return CustomDSFPositionIndicator(
                                      key: UniqueKey(),
                                      start: clipOffset?.start ?? Duration.zero,
                                      end: clipOffset?.end ??
                                          widget.manager.player.state.duration,
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                              ],
                              const Spacer(),
                              const SizedBox(width: 8),
                              ValueListenableBuilder(
                                valueListenable: shouldFullScreen,
                                builder: (context, value, child) {
                                  return IconButton(
                                    onPressed: () {
                                      shouldFullScreen.value = !value;
                                    },
                                    icon: isFullscreen(context)
                                        ? const Icon(Icons.fullscreen_exit)
                                        : const Icon(Icons.fullscreen),
                                    iconSize:
                                        _theme(context).buttonBarButtonSize,
                                    color: _theme(context).buttonBarButtonColor,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IgnorePointer(
                      child: Builder(
                        builder: (context) {
                          final spotlight = payload.spotlight;
                          if (spotlight == null) {
                            return const SizedBox();
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return ValueListenableBuilder<bool>(
                                valueListenable:
                                    widget.manager.isDisplayFocusTime,
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
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

MaterialDesktopVideoControlsThemeData _theme(BuildContext context) =>
    FullscreenInheritedWidget.maybeOf(context) == null
        ? MaterialDesktopVideoControlsTheme.maybeOf(context)?.normal ??
            kDefaultMaterialDesktopVideoControlsThemeData
        : MaterialDesktopVideoControlsTheme.maybeOf(context)?.fullscreen ??
            kDefaultMaterialDesktopVideoControlsThemeDataFullscreen;

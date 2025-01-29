import 'package:dio/dio.dart';
import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_display_tile.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_group_button.dart';
import 'package:enchanted_collection/enchanted_collection.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SelectClip extends StatelessWidget {
  final SwitchFramesController controller;
  const SelectClip({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final yt = YoutubeExplode();
    final dio = Dio();

    return ValueListenableBuilder(
        valueListenable: controller.payload,
        builder: (context, data, _) {
          final selectedPayloadEntry = data.selectedGroupName;

          return ListView(
            children: [
              if (data.payload.keys.length > 1) ...[
                Text(
                  'Other Video Groups:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ...data.payload.keys.splitIntoGroups(2).map(
                      (group) => Row(
                        children: group.map((GroupName name) {
                          final isSelected = name == selectedPayloadEntry;
                          return VideoGroupButton(
                            groupName: name,
                            isSelected: isSelected,
                            onTap: () {
                              controller.selectGroup(name);
                            },
                          );
                        }).toList(),
                      ),
                    ),
              ],
              const SizedBox(height: 8),
              Text(
                'Videos:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ...data.payload[selectedPayloadEntry]!.map(
                (VideosEntryPayload videoPayload) {
                  return VideoDisplayTile(
                    dio: dio,
                    yt: yt,
                    data: videoPayload,
                    isSelected: videoPayload.clipUuid == data.selectedClipUuid,
                    onTap: () {
                      controller.selectClip(videoPayload.clipUuid);
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}

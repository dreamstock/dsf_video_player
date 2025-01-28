import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_display_tile.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_group_button.dart';
import 'package:enchanted_collection/enchanted_collection.dart';
import 'package:flutter/material.dart';

class SelectClip extends StatelessWidget {
  final SwitchFramesController controller;
  const SelectClip({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.payload,
        builder: (context, payload, _) {
          final selectedPayloadEntry = payload.selectedGroupName;

          return ListView(
            children: [
              ...payload.payload.keys.splitIntoGroups(2).map(
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
              ...payload.payload[selectedPayloadEntry]!.map(
                (VideosEntryPayload data) {
                  return VideoDisplayTile(
                    data: data,
                    isSelected: data.clipUuid == payload.selectedClipUuid,
                    onTap: () {
                      controller.selectClip(data.videoUrl);
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}

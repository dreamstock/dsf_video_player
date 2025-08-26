import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';

class VideoGroupButton extends StatelessWidget {
  final bool isSelected;
  final GroupName groupName;
  final void Function() onTap;
  final bool isNew;
  const VideoGroupButton({
    super.key,
    required this.isSelected,
    required this.groupName,
    required this.onTap,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(66, 187, 53, 0)
                // ? const Color(0xFF1E1D1D).withOpacity(0.8)
                : const Color(0xFF1E1D1D).withOpacity(0.5),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF4A01).withOpacity(0.4)
                  : const Color(0xFF1E1D1D).withOpacity(0.8),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isNew)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        groupName,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[300],
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:media_kit_video/media_kit_video.dart';

class SelectRate extends StatefulWidget {
  const SelectRate({
    super.key,
    required this.controller,
    this.onExit,
    this.onEnter,
    this.onHover,
  });

  final void Function(PointerExitEvent)? onExit;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerHoverEvent)? onHover;
  final VideoController controller;

  @override
  State<SelectRate> createState() => _SelectRateState();
}

class _SelectRateState extends State<SelectRate> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isVisible = true;
        });
      },
      child: PortalTarget(
        visible: isVisible,
        anchor: const Aligned(
          follower: Alignment.bottomLeft,
          target: Alignment.bottomRight,
        ),
        portalFollower: TapRegion(
          onTapOutside: (event) {
            setState(() {
              isVisible = false;
            });
          },
          child: MouseRegion(
            onExit: widget.onExit,
            onEnter: widget.onEnter,
            onHover: widget.onHover,
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(9),
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: SizedBox(
                  height: 112,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xff1E1D1D).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8)),
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <double>[
                        1.0,
                        1.5,
                        2.0,
                        3.0,
                      ].map(
                        (rate) {
                          return InkWell(
                            splashColor: Colors.amber,
                            hoverColor: Colors.orange,
                            onTap: () {
                              widget.controller.player.setRate(rate);
                              setState(() {
                                isVisible = false;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4, top: 4, left: 16),
                              child: Text(
                                '${rate}x',
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff1E1D1D).withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.speed),
              const SizedBox(width: 4),
              StreamBuilder(
                stream: widget.controller.player.stream.rate,
                builder: (context, val) {
                  return Text(
                    '${val.data ?? 1}x',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

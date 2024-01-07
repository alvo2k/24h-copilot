import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DeletableActivityTag extends StatefulWidget {
  const DeletableActivityTag({
    super.key,
    required this.tag,
    required this.onDeleted,
  });

  final String tag;
  final VoidCallback onDeleted;

  @override
  State<DeletableActivityTag> createState() => _DeletableActivityTagState();
}

class _DeletableActivityTagState extends State<DeletableActivityTag>
    with TickerProviderStateMixin {
  late final _deleteAnimationController = AnimationController(
    vsync: this,
    duration: 300.ms,
  );
  late final _deleteAnimationController2 = AnimationController(
    vsync: this,
    duration: 300.ms,
  );
  late final _sizeAnimation =
      Tween<double>(begin: 1, end: 0).animate(_deleteAnimationController2);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: _sizeAnimation,
      child: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: InputChip(
          onDeleted: () {
            _deleteAnimationController.forward();
          },
          labelPadding: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          visualDensity: const VisualDensity(vertical: -4),
          color: MaterialStateProperty.all<Color>(
            Theme.of(context).cardColor,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            side: BorderSide(style: BorderStyle.none),
          ),
          label: Text(
            '#${widget.tag}',
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: Colors.green),
          ),
        )
            .animate(
              controller: _deleteAnimationController,
              autoPlay: false,
            )
            .scaleXY(
              end: 1.5,
              duration: 300.ms,
            )
            .callback(
              callback: (_) {
                _deleteAnimationController2.forward().then(
                      (_) => widget.onDeleted(),
                    );
              },
            )
            .shake(delay: 150.ms, rotation: pi / 12)
            .scaleXY(end: 0),
      ),
    );
  }
}

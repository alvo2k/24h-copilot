import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        labelPadding: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        visualDensity: const VisualDensity(vertical: -4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          side: BorderSide(style: BorderStyle.none),
        ),
        label: Text(
          '#$tag',
          overflow: TextOverflow.fade,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.green),
        ),
      ),
    );
  }
}

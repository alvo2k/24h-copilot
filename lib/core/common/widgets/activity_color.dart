import 'package:flutter/material.dart';

class ActivityColor extends StatelessWidget {
  const ActivityColor({
    super.key,
    required this.color,
    this.padding,
  });

  final Color color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 16,
          ),
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

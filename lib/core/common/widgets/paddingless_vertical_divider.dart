import 'package:flutter/material.dart';

class PaddinglessVerticalDivider extends StatelessWidget {
  const PaddinglessVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) => const VerticalDivider(
        width: 1,
        thickness: 1,
      );
}

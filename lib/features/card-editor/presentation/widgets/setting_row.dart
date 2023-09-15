import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  const SettingRow({
    required this.settingName,
    required this.children,
    super.key,
  });

  final String settingName;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$settingName:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ...children,
        ],
      ),
    );
  }
}

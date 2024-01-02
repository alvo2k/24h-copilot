import 'package:flutter/material.dart';

class BackupButton extends StatelessWidget {
  const BackupButton({
    super.key,
    required this.text,
    required this.picture,
    required this.onTap,
  });

  final String text;
  final Widget picture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(450, 200)),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 32,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 34),
                  child: Opacity(
                    opacity: Theme.of(context).brightness == Brightness.dark
                        ? .6
                        : 1,
                    child: picture,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

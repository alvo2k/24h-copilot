import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewTagTextField extends StatefulWidget {
  const NewTagTextField({super.key, required this.onSubmitted});

  final void Function(String) onSubmitted;

  @override
  State<NewTagTextField> createState() => _NewTagTextFieldState();
}

class _NewTagTextFieldState extends State<NewTagTextField>
    with SingleTickerProviderStateMixin {
  late final _controller = TextEditingController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: 600.ms,
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      // alignment: Alignment.centerRight,
      // clipBehavior: Clip.none,
      children: [
        TextField(
          controller: _controller,
          onSubmitted: (_) {
            widget.onSubmitted(_controller.text);
            _controller.clear();
          },
          style: const TextStyle(
            fontSize: 16,
            height: 2,
          ),
          strutStyle: const StrutStyle(
            height: 1,
            forceStrutHeight: true,
          ),
          decoration: InputDecoration(
            isCollapsed: true,
            prefixText: '  # ',
            // suffixText: '  ',
            suffixIconConstraints: BoxConstraints.loose(const Size(26, 25)),
            suffixIcon: IconButton.filled(
              onPressed: () {
                widget.onSubmitted(_controller.text);
                _controller.clear();
              },
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            )
                .animate(
                  controller: _animationController,
                  autoPlay: false,
                )
                .scaleXY()
                .rotate(),
            hintText: AppLocalizations.of(context)!.add,
            constraints: const BoxConstraints(maxWidth: 140),
          ),
        ),
      ],
    );
  }
}

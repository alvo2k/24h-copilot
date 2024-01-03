import 'package:flutter/material.dart';

class PaddinglessVerticalDivider extends StatelessWidget {
  const PaddinglessVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) => const VerticalDivider(
        width: 1,
        thickness: 1,
      );
}

class AnimatedPaddinglessVerticalDivider extends StatefulWidget {
  const AnimatedPaddinglessVerticalDivider({super.key});

  @override
  State<AnimatedPaddinglessVerticalDivider> createState() =>
      _AnimatedPaddinglessVerticalDividerState();
}

class _AnimatedPaddinglessVerticalDividerState
    extends State<AnimatedPaddinglessVerticalDivider>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => SizedBox(
        height: height * _animation.value,
        child: const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
      ),
    );
  }
}

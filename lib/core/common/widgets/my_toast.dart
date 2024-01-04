import 'package:flutter/material.dart';

class MyToast extends StatelessWidget {
  const MyToast(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: Text(text),
      ),
    );
  }
}

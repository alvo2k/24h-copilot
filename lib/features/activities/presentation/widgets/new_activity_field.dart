import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activities_bloc.dart';

class NewActivityField extends StatefulWidget {
  const NewActivityField({super.key});

  @override
  State<NewActivityField> createState() => _NewActivityFieldState();
}

class _NewActivityFieldState extends State<NewActivityField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (name) => _submitActivity(context, name),
        onEditingComplete: () => _focusNode.unfocus(),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          hintText: 'Enter a new activity',
          suffixIcon: IconButton(
            iconSize: 30,
            tooltip: 'Add activity',
            splashRadius: 20.0,
            icon: const Icon(Icons.play_circle_outline),
            onPressed: _controller.text.isEmpty
                ? null
                : () => _submitActivity(context, _controller.text),
          ),
        ),
      ),
    );
  }

  void _submitActivity(BuildContext context, String name) {
    if (name.isEmpty) return;

    BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivitiesEvent.switchActivity(name));

    _controller.clear();
    _focusNode.unfocus();
  }
}

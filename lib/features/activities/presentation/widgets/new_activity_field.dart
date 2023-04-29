import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/utils/constants.dart';
import '../bloc/activities_bloc.dart';

class NewActivityField extends StatefulWidget {
  const NewActivityField(this.listViewController, {super.key});

  final ScrollController listViewController;

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

  void _submitActivity(BuildContext context, String name) {
    if (name.isEmpty) return;
    if (name.trim().length > Constants.maxActivityName) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Activity name is too long',
        ),
      );
      return;
    }

    BlocProvider.of<ActivitiesBloc>(context)
        .add(ActivitiesEvent.switchActivity(name.trim()));

    _controller.clear();
    _focusNode.unfocus();
    // delay is needed to first load next activity and then scroll to it
    Future.delayed(const Duration(milliseconds: 500))
        .then((_) => widget.listViewController.animateTo(
              widget.listViewController.position.minScrollExtent,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        focusNode: _focusNode,
        controller: _controller,
        onSubmitted: (name) => _submitActivity(context, name),
        onEditingComplete: () => _focusNode.unfocus(),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          hintText: AppLocalizations.of(context)!.newActivityPrompt,
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
}

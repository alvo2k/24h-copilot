import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/utils/constants.dart';
import '../bloc/activities_bloc.dart';
import '../pages/activities_page.dart';

class NewActivityField extends StatefulWidget {
  const NewActivityField({super.key});

  @override
  State<NewActivityField> createState() => _NewActivityFieldState();
}

class _NewActivityFieldState extends State<NewActivityField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late final ScrollController listViewController;

  @override
  void initState() {
    super.initState();
    listViewController = ActivityScrollController.of(context).controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitActivity(BuildContext context, String name) {
    if (name.isEmpty) return;
    if (name.trim().length > Constants.maxActivityName) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: AppLocalizations.of(context)!.activityNameTooLong,
        ),
      );
      return;
    }

    context.read<ActivitiesBloc>().add(SwitchActivity(name.trim()));

    _controller.clear();
    _focusNode.unfocus();
    ActivityScrollController.of(context).animateToNewActivity();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorHeight: 25,
      textCapitalization: TextCapitalization.sentences,
      focusNode: _focusNode,
      controller: _controller,
      onSubmitted: (name) => _submitActivity(context, name),
      onEditingComplete: () => _focusNode.unfocus(),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        fillColor: Theme.of(context).cardColor,
        hintText: AppLocalizations.of(context)!.newActivityPrompt,
        suffixIcon: IconButton(
          color: Theme.of(context).colorScheme.primary,
          iconSize: 30,
          tooltip: AppLocalizations.of(context)!.chooseActivity,
          splashRadius: 20.0,
          icon: const Icon(Icons.play_circle_outline),
          onPressed: _controller.text.isEmpty
              ? null
              : () => _submitActivity(context, _controller.text),
        ),
      ),
    );
  }
}

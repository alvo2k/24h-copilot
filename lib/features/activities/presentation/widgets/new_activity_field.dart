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
        CustomSnackBar.error(
          message: AppLocalizations.of(context)!.activityNameTooLong,
        ),
      );
      return;
    }

    context.read<ActivitiesBloc>().add(SwitchActivity(name.trim()));

    _controller.clear();
    _focusNode.unfocus();
    if (widget.listViewController.hasClients) {
      widget.listViewController.animateTo(
        widget.listViewController.position.minScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      strutStyle: const StrutStyle(
        // centers cursor and text
        height: 1.2,
        leading: .7,
      ),
      cursorHeight: 20,
      textCapitalization: TextCapitalization.sentences,
      focusNode: _focusNode,
      controller: _controller,
      onSubmitted: (name) => _submitActivity(context, name),
      onEditingComplete: () => _focusNode.unfocus(),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/activity_settings.dart';
import '../bloc/card_editor_bloc.dart';
import '../widgets/activity_settings_card.dart';
import '../widgets/empty_card_editor_illustration.dart';
import 'activity_settings_page.dart';

class ActivitiesSettingsPage extends StatelessWidget {
  const ActivitiesSettingsPage(
      {this.onActivitySelected = _defaultHandler, super.key});

  final void Function(BuildContext context, ActivitySettings activity)
      onActivitySelected;

  static void _defaultHandler(
          BuildContext context, ActivitySettings activity) =>
      context.go('/card_editor/:${activity.name}', extra: activity);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardEditorBloc, CardEditorState>(
        builder: (context, state) {
      if (state is CardEditorStateInitial) {
        BlocProvider.of<CardEditorBloc>(context).add(LoadActivitiesSettings());
        return const Center(child: CircularProgressIndicator.adaptive());
      } else if (state is CardEditorStateLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else if (state is CardEditorStateLoaded) {
        if (state.activitiesSettings.isEmpty) {
          return const EmptyCardEditorIllustration();
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: state.activitiesSettings.length,
          itemBuilder: (context, index) {
            final activity = state.activitiesSettings[index];
            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ActivitySettingsCard(
                    activity: activity,
                    onPressed: () => onActivitySelected(context, activity),
                  ),
                ),
              ],
            );
          },
        );
      } else if (state is CardEditorStateFailure) {
        return Center(child: Text(state.message));
      }
      return const Center(child: Text('Unknown state'));
    });
  }
}

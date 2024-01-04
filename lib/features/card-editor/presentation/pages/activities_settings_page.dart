import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/activity_settings_card.dart';
import '../../../../core/common/widgets/common_drawer.dart';
import '../../../../core/utils/constants.dart';
import '../bloc/card_editor_bloc.dart';
import '../widgets/empty_card_editor_illustration.dart';

class ActivitiesSettingsPage extends StatelessWidget {
  const ActivitiesSettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editActivities),
      ),
      drawer: MediaQuery.of(context).size.width <= Constants.mobileWidth
          ? const CommonDrawer()
          : null,
      body: BlocBuilder<CardEditorBloc, CardEditorState>(
          builder: (context, state) {
        if (state is CardEditorStateInitial) {
          BlocProvider.of<CardEditorBloc>(context)
              .add(LoadActivitiesSettings());
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    ActivitySettingsCard.fromActivitySettings(
                      activity,
                      onPressed: () => context.go(
                        '/card_editor/:${activity.name}',
                        extra: activity,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (state is CardEditorStateFailure) {
          return Center(child: Text(state.type.localize(context)));
        }
        return const Center(child: Text('Unknown state'));
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../bloc/card_editor_bloc.dart';
import '../widgets/activity_settings_card.dart';
import 'activity_settings_page.dart';

class ActivitiesSettingsPage extends StatelessWidget {
  const ActivitiesSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.editActivities,
        ),
      ),
      body: BlocConsumer<CardEditorBloc, CardEditorState>(
        listener: (context, state) {
          if (state is CardEditorStateFailure) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state.message,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CardEditorStateInitial) {
            BlocProvider.of<CardEditorBloc>(context)
                .add(LoadActivitiesSettings());
            return const Placeholder();
          } else if (state is CardEditorStateLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is CardEditorStateLoaded) {
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ActivitySettingsPage(
                                  activity: activity,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                });
          } else if (state is CardEditorStateFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }
}

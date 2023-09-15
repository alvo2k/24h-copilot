import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/card-editor/presentation/pages/activities_settings_page.dart';
import '../../../features/card-editor/presentation/pages/activity_settings_page.dart';
import '../../common/activity_settings.dart';
import '../../common/bloc/card_editor_screen_cubit.dart';
import '../../common/widgets/navigation_rail.dart';

class CardEditorDesktop extends StatelessWidget {
  const CardEditorDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editActivities,
        ),
      ),
      body: BlocBuilder<CardEditorScreenCubit, ActivitySettings?>(
        builder: (context, state) => Row(
          children: [
            const NavigatorRail(),
            const VerticalDivider(),
            Expanded(
                child: ActivitiesSettingsPage(
                    onActivitySelected: (context, activity) => context
                        .read<CardEditorScreenCubit>()
                        .onActivitySelected(activity))),
            if (state != null) const VerticalDivider(),
            if (state != null)
              Expanded(
                child: ActivitySettingsPage(
                  activity: state,
                  key: ValueKey(state.name),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

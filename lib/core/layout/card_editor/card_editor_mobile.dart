import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/card-editor/presentation/pages/activities_settings_page.dart';

class CardEditorMobile extends StatelessWidget {
  const CardEditorMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editActivities,
        ),
      ),
      body: const ActivitiesSettingsPage(),
    );
  }
}

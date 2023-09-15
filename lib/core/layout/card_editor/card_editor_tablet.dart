import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features/card-editor/presentation/pages/activities_settings_page.dart';
import '../../common/widgets/navigation_rail.dart';

class CardEditorTablet extends StatelessWidget {
  const CardEditorTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.editActivities,
        ),
      ),
      body: const Row(
        children: [
          NavigatorRail(),
          VerticalDivider(),
          Expanded(child: ActivitiesSettingsPage()),
        ],
      ),
    );
  }
}

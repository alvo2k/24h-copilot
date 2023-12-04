import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/entities.dart';

class ActivityHeatMap extends StatelessWidget {
  const ActivityHeatMap(this.data, {super.key});

  final HeatMapData data;

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      colorsets: {0: data.activity.color},
      datasets: data.dataset,
      scrollable: true,
      showColorTip: false,
      defaultColor: Theme.of(context).cardColor,
      weekStartsWith: DateFormat('', AppLocalizations.of(context)!.localeName)
              .dateSymbols
              .FIRSTDAYOFWEEK +
          1,
    );
  }
}

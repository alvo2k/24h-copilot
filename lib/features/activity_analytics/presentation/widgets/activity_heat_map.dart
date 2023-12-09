import 'dart:ui';

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
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView(
        children: [
          Stack(
            children: [
              HeatMap(
                colorsets: {0: data.activity.color},
                datasets: data.dataset,
                scrollable: true,
                showColorTip: false,
                defaultColor: Theme.of(context).cardColor,
                weekStartsWith:
                    DateFormat('', AppLocalizations.of(context)!.localeName)
                            .dateSymbols
                            .FIRSTDAYOFWEEK +
                        1,
              ),
              if (data.dataset?.isEmpty ?? false)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          AppLocalizations.of(context)!.heatMapSetGoal,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(AppLocalizations.of(context)!.neverStarted),
              const SizedBox(width: 4),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).cardColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.reached),
              const SizedBox(width: 4),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: data.activity.color,
                ),
              ),
              const SizedBox(width: 32)
            ],
          ),
        ],
      ),
    );
  }
}

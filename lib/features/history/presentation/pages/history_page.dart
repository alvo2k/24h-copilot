import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/common/widgets/activity_search_bar.dart';
import '../../../../core/common/widgets/activity_settings_card.dart';
import '../../../../core/common/widgets/common_drawer.dart';
import '../../../../core/utils/constants.dart';
import '../../../activities/presentation/widgets/activity_day_date.dart';
import '../bloc/history_bloc.dart';
import '../widgets/empty_history_illustration.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Widget _buildDate(DateTime from, DateTime to, BuildContext context) =>
      DateUtils.dateOnly(to).isAtSameMomentAs(from)
          ? Text(
              ActivityDayDate.formatDate(to, context),
              style: Theme.of(context).textTheme.headlineMedium,
            )
          : Text(
              '${ActivityDayDate.formatDate(
                from,
                context,
                DateFormat.MONTH_DAY,
              )} - ${ActivityDayDate.formatDate(
                to,
                context,
                DateFormat.MONTH_DAY,
              )}',
              style: Theme.of(context).textTheme.headlineMedium,
            );

  Widget _buildPie(Map<String, double> dataMap, List<Color> colorList,
          BuildContext context) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: PieChart(
          chartType: ChartType.ring,
          ringStrokeWidth: 12,
          chartRadius: min(MediaQuery.of(context).size.width / 1.7, 350),
          legendOptions: const LegendOptions(showLegends: false),
          chartValuesOptions: const ChartValuesOptions(showChartValues: false),
          colorList: colorList,
          dataMap: dataMap,
        ),
      );

  void _listener(BuildContext context, HistoryState state) {
    if (state is HistoryFailure) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: state.type.localize(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: _listener,
      builder: (context, state) => switch (state) {
        HistoryLoadedNoData() => const EmptyHistoryIllustration(),
        HistoryLoaded() => Scaffold(
            appBar: ActivitySearchBar(
              showDatePicker: true,
              dropShadow: true,
              title: AppLocalizations.of(context)!.history,
            ),
            drawer: MediaQuery.of(context).size.width <= Constants.mobileWidth
                ? const CommonDrawer()
                : null,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _buildDate(
                      state.data.from,
                      state.data.to,
                      context,
                    ),
                  ),
                  _buildPie(
                    state.data.dataMap,
                    state.data.colorList,
                    context,
                  ),
                  for (final activity in state.data.activities)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ActivitySettingsCard(
                        name: activity.name,
                        color: activity.color,
                        tags: activity.tags,
                        goal: activity.goal != null
                            ? Duration(minutes: activity.goal!)
                            : null,
                        startTime: activity.startTime,
                        endTime: activity.endTime,
                      ),
                    ),
                ],
              ),
            ),
          ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

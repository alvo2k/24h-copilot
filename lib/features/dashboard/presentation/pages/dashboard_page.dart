import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../../core/common/bloc/navigation_cubit.dart';
import '../../../../core/common/widgets/activity_search_bar.dart';
import '../../../../core/common/widgets/common_drawer.dart';
import '../../../../core/utils/constants.dart';
import '../../../activities/presentation/widgets/activity_day_date.dart';
import '../../../activities/presentation/widgets/activity_list_tile.dart';
import '../../domain/entities/pie_chart_data.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/empty_dashboard_illustration.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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

  Widget _buildActivities(PieChartData data) {
    return Column(
      children: [
        for (final activity in data.activities)
          ActivityListTile(
            activity,
            minimalVersion: true,
            padding: 0,
            hideEmojiPicker: true,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) => switch (state) {
        DashboardInitial() => () {
            context.read<DashboardBloc>().add(LoadInitialData());

            return const Center(child: CircularProgressIndicator.adaptive());
          }(),
        DashboardLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        DashboardFailure() => Center(child: Text(state.type.localize(context))),
        DashboardLoadedNoData() => const EmptyDashboardIllustration(),
        DashboardLoaded() => Scaffold(
            appBar: buildSearchAppbar(
              context,
              title: AppLocalizations.of(context)!.dashboard,
              actionButtons: [
                IconButton(
                  icon: const Icon(Icons.date_range_outlined),
                  tooltip: AppLocalizations.of(context)!.dateRange,
                  onPressed: () =>
                      context.read<NavigationCubit>().rangePicker(context),
                ),
              ],
              onSuggestionTap: (search) => context
                  .read<NavigationCubit>()
                  .onSuggestionTap(search),
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
                  _buildActivities(state.data),
                ],
              ),
            ),
          ),
      },
    );
  }
}

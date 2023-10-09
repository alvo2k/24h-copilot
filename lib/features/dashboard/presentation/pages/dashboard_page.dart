import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
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
        builder: (context, state) {
      if (state is DashboardLoading) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      if (state is DashboardFailure) {
        return Center(child: Text(state.message));
      }
      if (state is DashboardLoaded) {
        final bloc = BlocProvider.of<DashboardBloc>(context);
        return Obx(() {
          if (bloc.data.value != null) {
            return Scaffold(
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
                    .onSuggestionTap(context, search),
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
                        bloc.data.value!.from,
                        bloc.data.value!.to,
                        context,
                      ),
                    ),
                    _buildPie(
                      bloc.data.value!.dataMap,
                      bloc.data.value!.colorList,
                      context,
                    ),
                    _buildActivities(bloc.data.value!),
                  ],
                ),
              ),
            );
          } else {
            return const EmptyDashboardIllustration();
          }
        });
      }
      if (state is DashboardInitial) {
        state.firstRecordDate.then((date) {
          final today = DateUtils.dateOnly(DateTime.now());
          final from = () {
            if (date != null) {
              if (date.isAfter(today.subtract(const Duration(days: 7)))) {
                return date;
              }
              return today.subtract(const Duration(days: 7));
            }
            return DateUtils.dateOnly(DateTime.now());
          }();
          // load last 7 days or load entire [today]
          BlocProvider.of<DashboardBloc>(context)
              .add(DashboardLoad(from, today));
        });
        return const Center(child: CircularProgressIndicator.adaptive());
      }
      return const Center(child: Text('Unknown state'));
    });
  }
}

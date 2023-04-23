import 'dart:math';

import 'package:copilot/features/activities/presentation/widgets/activity_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../activities/presentation/widgets/activity_day_date.dart';
import '../../domain/entities/pie_chart_data.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _buildDate(DateTime from, DateTime to, BuildContext context) =>
      DateUtils.dateOnly(to).isAtSameMomentAs(from)
          ? Text(
              ActivityDayDate.formatDate(to, context),
              style: const TextStyle(fontSize: 28),
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
              style: const TextStyle(fontSize: 28),
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
            duration: Duration(minutes: data.dataMap[activity.name]!.toInt()),
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
      if (state is DashboardFailure) return Center(child: Text(state.message));
      if (state is DashboardLoaded) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildDate(state.data.from, state.data.to, context),
              ),
              _buildPie(state.data.dataMap, state.data.colorList, context),
              _buildActivities(state.data),
            ],
          ),
        );
      }
      if (state is DashboardInitial) {
        final from = DateUtils.dateOnly(DateTime.now())
            .subtract(const Duration(days: 3));
        final to = DateTime.now();
        BlocProvider.of<DashboardBloc>(context).add(DashboardLoad(from, to));
        return const Center(child: Text('State initial'));
      }
      return const Center(child: Text('Unknown state'));
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activity_analytics_bloc.dart';
import '../widgets/view.dart';

class ActivityAnalyticsPage extends StatefulWidget {
  const ActivityAnalyticsPage(this.activityName, {super.key});

  final String activityName;

  @override
  State<ActivityAnalyticsPage> createState() => _ActivityAnalyticsPageState();
}

class _ActivityAnalyticsPageState extends State<ActivityAnalyticsPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<ActivityAnalyticsBloc>()
        .add(LoadActivityAnalytics(widget.activityName));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityAnalyticsBloc, ActivityAnalyticsState>(
      builder: (context, state) => switch (state.status) {
        ActivityAnalyticsStatus.initial =>
          const Center(child: CircularProgressIndicator.adaptive()),
        ActivityAnalyticsStatus.loaded => Scaffold(
            appBar: AppBar(title: Text(widget.activityName)),
            body: ActivityHeatMap(state.data!),
          ),
        ActivityAnalyticsStatus.failure =>
          Center(child: Text(state.failure!.localize(context))),
        ActivityAnalyticsStatus.loading =>
          const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

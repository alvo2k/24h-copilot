import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/common/widgets/activity_color.dart';
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

  void _listener(BuildContext context, ActivityAnalyticsState state) {
    if (state.status == ActivityAnalyticsStatus.failure) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: state.failure!.localize(context),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityAnalyticsBloc, ActivityAnalyticsState>(
      listener: _listener,
      builder: (context, state) => switch (state.status) {
        ActivityAnalyticsStatus.initial =>
          const Center(child: CircularProgressIndicator.adaptive()),
        ActivityAnalyticsStatus.loading =>
          const Center(child: CircularProgressIndicator.adaptive()),
        _ => state.data != null
            ? Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      ActivityColor(color: state.data!.activity.color),
                      Text(widget.activityName),
                    ],
                  ),
                ),
                body: ActivityHeatMap(state.data!),
              )
            : Center(child: Text(state.failure!.localize(context))),
      },
    );
  }
}

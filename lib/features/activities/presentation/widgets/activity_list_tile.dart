import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scaled_app/scaled_app.dart';

import '../../../../core/common/widgets/activity_settings_card.dart';
import '../../domain/entities/activity.dart';
import '../bloc/activities_bloc.dart';

class ActivityListTile extends StatefulWidget {
  const ActivityListTile(this.activity, {super.key});

  final Activity activity;

  @override
  State<ActivityListTile> createState() => _ActivityListTileState();
}

class _ActivityListTileState extends State<ActivityListTile>
    with SingleTickerProviderStateMixin {
  static const cardHeight = 125.0;

  late final _shimmerController = AnimationController(
    vsync: this,
    duration: 1.seconds,
  );

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ActivityListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity != widget.activity) {
      _shimmerController.forward(from: 0.0);
    }
  }

  Widget _buildLeftBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 8),
      child: Container(
        color: widget.activity.color,
        width: 4,
        height: _determineLeftBarHeight(
            widget.activity.endTime == null
                ? DateTime.now().difference(widget.activity.startTime)
                : widget.activity.endTime!
                    .difference(widget.activity.startTime),
            context),
      ),
    );
  }

  double _determineLeftBarHeight(Duration duration, BuildContext context) {
    final hourValue = 28.0 / ScaledWidgetsFlutterBinding.instance.scale;
    // todo: make this dynamic (maxHeight - appBarHeight - bottomBarHeight)
    final maxHeight = (MediaQuery.of(context).size.height /
            ScaledWidgetsFlutterBinding.instance.scale) -
        200;
    final height = cardHeight + (hourValue * duration.inHours);

    return height > maxHeight ? maxHeight : height;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLeftBar(context).animate().slideX(begin: -1),
        Flexible(
          child: ActivitySettingsCard(
            name: widget.activity.name,
            color: widget.activity.color,
            goal: widget.activity.goal != null
                ? Duration(minutes: widget.activity.goal!)
                : null,
            goalReached: widget.activity.goalMet,
            tags: widget.activity.tags,
            startTime: widget.activity.startTime,
            endTime: widget.activity.endTime,
            emoji: widget.activity.emoji,
            onEmojiSelected: widget.activity.canChangeEmoji
                ? (newEmoji) => context.read<ActivitiesBloc>().add(
                      AddEmoji(
                        widget.activity.recordId,
                        newEmoji,
                      ),
                    )
                : null,
          )
              .animate()
              .fadeIn()
              .slideX(begin: 1.5, end: 0)
              .animate(controller: _shimmerController, autoPlay: false)
              .shimmer(duration: _shimmerController.duration),
        ),
      ],
    );
  }
}

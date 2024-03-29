import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/edit_mode_cubit.dart';
import 'recomend_activity_chip.dart';

class RecommendedActivities extends StatefulWidget {
  const RecommendedActivities({super.key, required this.child});

  final Widget child;

  @override
  State<RecommendedActivities> createState() => _RecommendedActivitiesState();
}

class _RecommendedActivitiesState extends State<RecommendedActivities>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late final _animationController = AnimationController(
    vsync: this,
    duration: kThemeAnimationDuration,
  );

  late final _sizeTween =
      Tween<double>(begin: 1, end: 0).animate(_animationController);

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditModeCubit, bool>(
      listener: (context, state) => state
          ? _animationController.forward()
          : _animationController.reverse(),
      child: SizeTransition(
        sizeFactor: _sizeTween,
        child: Padding(
          padding: const EdgeInsets.only(left: 42, right: 8, bottom: 8),
          child: Card(
            elevation: 0,
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                BlocBuilder<ActivitiesBloc, ActivitiesState>(
                  buildWhen: (previous, current) =>
                      current is! Loaded ||
                      previous.pageState.recommendedActivities !=
                          current.pageState.recommendedActivities,
                  builder: (BuildContext context, ActivitiesState state) {
                    if (state is! Loaded ||
                        state.pageState.recommendedActivities.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return SizedBox(
                      height: 40,
                      width: 450,
                      child: Scrollbar(
                        thickness: Platform.isAndroid || Platform.isIOS ? 0 : 8,
                        controller: _scrollController,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              state.pageState.recommendedActivities.length,
                          itemBuilder: (context, index) {
                            final activity =
                                state.pageState.recommendedActivities[index];
                            return RecomendActivityChip(
                              name: activity.name,
                              color: activity.color,
                              isFirstRecomended: index == 0,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<ActivitiesBloc, ActivitiesState>(
                  builder: (context, state) {
                    return Padding(
                      padding: state is! Loaded ||
                              state.pageState.recommendedActivities.isEmpty
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 48,
                        width: 450,
                        child: widget.child,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

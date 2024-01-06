import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/edit_mode_cubit.dart';
import '../pages/activities_page.dart';
import 'activity_day_date.dart';
import 'activity_day_widget.dart';
import 'empty_activities_illustration.dart';
import 'lazy_loading_indicator.dart';

class ActivityListView extends StatefulWidget {
  const ActivityListView({super.key});

  @override
  State<ActivityListView> createState() => _ActivityListViewState();
}

class _ActivityListViewState extends State<ActivityListView>
    with TickerProviderStateMixin {
  late final AnimationController separatorController;
  late final Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    separatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: separatorController,
        curve: Curves.easeInCubic,
      ),
    );
  }

  @override
  void dispose() {
    separatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ActivityScrollController.of(context).controller;
    return BlocListener<EditModeCubit, bool>(
      listener: (context, state) =>
          state ? separatorController.forward() : separatorController.reverse(),
      child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
        builder: (context, state) {
          return switch (state) {
            Initial() => const Center(child: CircularProgressIndicator()),
            Loading() => const Center(child: CircularProgressIndicator()),
            Loaded() => () {
                if (state.pageState.isEmpty) {
                  return const EmptyActivitiesIllustration();
                }

                return ListView.builder(
                  key: const PageStorageKey('activityListView'),
                  controller: controller,
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const RangeMaintainingScrollPhysics(),
                  itemCount: state.pageState.activityDays.length,
                  itemBuilder: (context, index) {
                    final day = state.pageState.activityDays[index];
                    if (day.activitiesInThisDay.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (index == 0) {
                      // if this is today, print icon at the end
                      return StickyHeader(
                        header: ActivityDayDate(day.date),
                        content: Column(
                          children: [
                            if (index ==
                                state.pageState.activityDays.length - 1)
                              const LazyLoadingIndicator(),
                            ActivityDayWidget(
                              day,
                              sizeAnimation: separatorController,
                              opacityAnimation: opacity,
                            ),
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 29.0,
                                    vertical: 16,
                                  ),
                                  child: Icon(Icons.access_time),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == state.pageState.activityDays.length - 1) {
                      return StickyHeader(
                        header: ActivityDayDate(day.date),
                        content: Column(
                          children: [
                            const LazyLoadingIndicator(),
                            ActivityDayWidget(
                              day,
                              sizeAnimation: separatorController,
                              opacityAnimation: opacity,
                            ),
                          ],
                        ),
                      );
                    }
                    return StickyHeader(
                      header: ActivityDayDate(day.date),
                      content: ActivityDayWidget(
                        day,
                        sizeAnimation: separatorController,
                        opacityAnimation: opacity,
                      ),
                    );
                  },
                );
              }(),
            Failure() => Center(child: Text(state.type.localize(context))),
          };
        },
      ),
    );
  }
}

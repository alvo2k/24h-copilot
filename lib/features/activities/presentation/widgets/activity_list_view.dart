import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../bloc/activities_bloc.dart';
import '../pages/activities_page.dart';
import 'activity_day_date.dart';
import 'activity_day_widget.dart';
import 'empty_activities_illustration.dart';

class ActivityListView extends StatelessWidget {
  const ActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ActivityScrollController.of(context).controller;
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
      builder: (context, state) {
        return switch (state) {
          Initial() => const Center(child: CircularProgressIndicator()),
          Loading() => const Center(child: CircularProgressIndicator()),
          Loaded() => () {
              if (state.pageState.activityDays.length == 1 &&
                  state.pageState.activityDays[0].activitiesInThisDay.isEmpty) {
                return const EmptyActivitiesIllustration();
              }
              return ListView.builder(
                key: const PageStorageKey('activityListView'),
                controller: controller,
                shrinkWrap: true,
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
                    Future(() {
                      // calls loadMoreDays() witch loads prev. day
                      if (controller.hasClients) {
                        controller.position.notifyListeners();
                      }
                    });
                    // if this is today, print icon at the end
                    return StickyHeader(
                      header: ActivityDayDate(day.date),
                      content: Column(
                        children: [
                          ActivityDayWidget(day),
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 29.0, vertical: 16),
                                child: Icon(Icons.access_time),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  if (index == state.pageState.activityDays.length - 1 &&
                      day.activitiesInThisDay.isNotEmpty) {
                    return StickyHeader(
                      header: ActivityDayDate(day.date),
                      content: Column(children: [
                        // Adds loading indicator at top of the list.
                        // Empty ActivitiesDay means all data was loaded and no indicator needed
                        const CircularProgressIndicator(),
                        ActivityDayWidget(day),
                      ]),
                    );
                  }
                  return StickyHeader(
                    header: ActivityDayDate(day.date),
                    content: ActivityDayWidget(day),
                  );
                },
              );
            }(),
          Failure() => Center(child: Text(state.type.localize(context))),
        };
      },
    );
  }
}

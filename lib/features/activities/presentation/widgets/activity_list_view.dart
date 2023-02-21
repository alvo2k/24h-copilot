import 'package:flutter/material.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../bloc/activities_bloc.dart';
import 'activity_day.dart';
import 'activity_day_date.dart';

class ActivityListView extends StatelessWidget {
  const ActivityListView(this.controller, {super.key});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return SealedBlocBuilder4<ActivitiesBloc, ActivitiesState, Initial, Loading,
        Loaded, Failure>(
      builder: (context, state) => state(
        (initial) {
          //activityBloc.add(ActivitiesEvent.loadActivities(DateTime.now()));
          return const Center(child: CircularProgressIndicator());
        },
        (loading) => const Center(child: CircularProgressIndicator()),
        (loaded) {
          return SingleChildScrollView(
            controller: controller,
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              itemCount: loaded.days.length,
              itemBuilder: (context, index) {
                // if (loaded.days.length == 1 &&
                //     loaded.days[0].activitiesInThisDay.isEmpty) {
                //   // app launches for the first time
                //   return const Text('First launch');
                // }
                final day = loaded.days[index];
                if (day.activitiesInThisDay.isEmpty) {
                  return const SizedBox.shrink();
                }
                if (index == 0) {
                  Future(() {
                    // calls loadMoreDays() witch loads prev. day
                    controller.position.notifyListeners();
                  });
                  // if this is today, print icon at the end
                  return Column(
                    children: [
                      ActivityDayDate(day.date),
                      ActivityDayWidget(day),
                      Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 29.0, vertical: 16),
                            child: Icon(Icons.access_time),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                if (index == loaded.days.length - 1 &&
                    day.activitiesInThisDay.isNotEmpty) {
                  return Column(children: [
                    // adds loading indicator at top of the list. Empty ActivitiesDay means all data was loaded and no indicator needed
                    const CircularProgressIndicator(),
                    ActivityDayDate(day.date),
                    ActivityDayWidget(day),
                  ]);
                }
                return Column(
                  children: [
                    ActivityDayDate(day.date),
                    ActivityDayWidget(day),
                  ],
                );
              },
            ),
          );
        },
        (failure) => Center(child: Text(failure.message)),
      ),
    );
  }
}

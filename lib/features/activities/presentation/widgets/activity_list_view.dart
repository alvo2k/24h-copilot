import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../bloc/activities_bloc.dart';
import 'activity_day_date.dart';
import 'activity_day_widget.dart';
import 'empty_activities_illustration.dart';

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
          final bloc = BlocProvider.of<ActivitiesBloc>(context);
          return Obx(
            () {
              if (bloc.loadedActivities.length == 1 &&
                  bloc.loadedActivities[0].activitiesInThisDay.isEmpty) {
                return const EmptyActivitiesIllustration();
              }
              return ListView.builder(
                key: const PageStorageKey('activityListView'),
                controller: controller,
                shrinkWrap: true,
                reverse: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                itemCount: bloc.loadedActivities.length,
                itemBuilder: (context, index) {
                  final day = bloc.loadedActivities[index];
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
                    return Column(
                      children: [
                        ActivityDayDate(day.date),
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
              );
            },
          );
        },
        (failure) => Center(child: Text(failure.message)),
      ),
    );
  }
}

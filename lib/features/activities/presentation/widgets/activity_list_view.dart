import 'package:copilot/features/activities/presentation/widgets/activity_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../bloc/activities_bloc.dart';

class ActivityListView extends StatelessWidget {
  const ActivityListView({super.key});

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
        (loaded) => ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: loaded.activities.length + 1,
          itemBuilder: (context, index) {
            // in order to display last icon in separatorBuilder
            if (index == loaded.activities.length) {
              return Container();
            }
            return ActivityListTile(loaded.activities[index]);
          },
          separatorBuilder: (context, index) {
            late Widget separator;
            try {
              final endTimeText = loaded.activities[index].endTime
                  .toString()
                  .substring(11, 16);
              separator = Text(endTimeText);
            } on RangeError catch (_) {
              separator = Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.black38,
                    ),
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 16,
              ),
              child: separator,
            );
          },
        ),
        (failure) => Center(child: Text(failure.message)),
      ),
    );
  }
}

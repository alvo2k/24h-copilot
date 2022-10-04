import 'package:flutter/material.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

import '../bloc/activities_bloc.dart';
import 'activity_list_tile.dart';

class SliverActivityListView extends StatelessWidget {
  const SliverActivityListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SealedBlocBuilder4<ActivitiesBloc, ActivitiesState, Initial, Loading,
        Loaded, Failure>(
      builder: (context, state) => state(
        (initial) => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())),
        (loading) => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator())),
        (loaded) => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              // in order to display last icon
              if (index == loaded.activities.length) {
                return Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                );
              }
              return ActivityListTile(loaded.activities[index]);
            },
            childCount: loaded.activities.length + 1,
          ),
        ),
        (failure) =>
            SliverToBoxAdapter(child: Center(child: Text(failure.message))),
      ),
    );
  }
}

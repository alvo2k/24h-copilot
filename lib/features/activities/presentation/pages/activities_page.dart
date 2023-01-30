import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/activity_day.dart';
import '../bloc/activities_bloc.dart';
import '../widgets/activity_list_view.dart';
import '../widgets/new_activity_field.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = ScrollController(initialScrollOffset: 9999);
    final controller = ScrollController();

    void loadMoreDays() {
      // load next day
      if (controller.position.extentAfter < 20) {
        var activitiesBlock = BlocProvider.of<ActivitiesBloc>(context);

        late DateTime dateToLoad;
        late ActivityDay lastLoadedActivityDay;
        activitiesBlock.state.join(
          (_) => null,
          (_) => null,
          (loaded) {
            lastLoadedActivityDay = loaded.days.last;
            dateToLoad =
                lastLoadedActivityDay.date.subtract(const Duration(days: 1));
          },
          (_) => null,
        );

        if (lastLoadedActivityDay.activitiesInThisDay.isEmpty) {
          // all activities in DB allready loaded
          controller.removeListener(loadMoreDays);
          return;
        }
        activitiesBlock.add(ActivitiesEvent.loadActivities(dateToLoad));
      }
    }

    controller.addListener(loadMoreDays);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: const Text('Activities'),
        // actions: [
        //   IconButton(
        //     icon: SvgPicture.asset('assets/icons/edit_mode.svg'),
        //     tooltip: 'Edit mode',
        //     onPressed: () {},
        //   ),
        // ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: const [
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text('Drawer Header'),
      //       ),
      //       TagsSetter(),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          Expanded(child: ActivityListView(controller)),
          NewActivityField(controller),
        ],
      ),
    );
  }
}

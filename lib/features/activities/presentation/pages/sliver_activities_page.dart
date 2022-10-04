import 'package:copilot/features/activities/presentation/widgets/new_activity_field.dart';
import 'package:copilot/features/activities/presentation/widgets/sliver_activity_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SliverActivitiesPage extends StatelessWidget {
  const SliverActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Colors.white70,
            foregroundColor: const Color.fromARGB(255, 0, 0, 0),
            centerTitle: true,
            title: const Text('Activities'),
            actions: [
              IconButton(
                icon: SvgPicture.asset('assets/icons/edit_mode.svg'),
                tooltip: 'Edit mode',
                onPressed: () {},
              ),
            ],
          ),
          const SliverActivityListView(),
          const SliverToBoxAdapter(
            child: NewActivityField(),
          )
        ],
      ),
    );
  }
}

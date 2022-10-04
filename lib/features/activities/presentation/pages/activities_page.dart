import 'package:flutter/material.dart';

import '../widgets/activity_list_view.dart';
import '../widgets/new_activity_field.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        children: const [
          Expanded(child: ActivityListView()),
          NewActivityField(),
        ],
      ),
    );
  }
}

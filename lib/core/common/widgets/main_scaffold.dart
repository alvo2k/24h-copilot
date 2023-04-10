import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/activities/presentation/bloc/edit_mode_cubit.dart';
import '../../../features/activities/presentation/pages/activities_page.dart';
import 'common_drawer.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;

  final List<Widget> _pages = [
    const ActivitiesPage(),
    const Center(child: Icon(Icons.dashboard)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.activities),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
              icon: SvgPicture.asset('assets/icons/edit_mode.svg'),
              tooltip: 'Edit mode',
              onPressed: () {
                BlocProvider.of<EditModeCubit>(context).toggle();
              },
            ),
          ),
        ],
      ),
      drawer: const CommonDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
      body: _pages.elementAt(currentIndex),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/activities_bloc.dart';
import '../pages/activities_page.dart';

class RecomendActivityChip extends StatelessWidget {
  const RecomendActivityChip({
    super.key,
    required this.name,
    required this.color,
    this.isFirstRecomended = false,
  });

  final String name;
  final Color color;
  final bool isFirstRecomended;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 8,
        top: 8,
        left: isFirstRecomended ? 8 : 0,
      ),
      // TODO change to chip with less height
      child: TextButton.icon(
        label: Text(
          name,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        onPressed: () {
          context.read<ActivitiesBloc>().add(
                SwitchActivity(name),
              );
          ActivityScrollController.of(context).animateToNewActivity();
        },
        icon: CircleAvatar(
          radius: 9,
          backgroundColor: color,
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 8,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

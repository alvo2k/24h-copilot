import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyActivitiesIllustration extends StatelessWidget {
  const EmptyActivitiesIllustration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Image.asset(
            'assets/illustrations/empty_activities.png',
            width: min(MediaQuery.of(context).size.width, 450),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Text(
              AppLocalizations.of(context)!.tutorialPrompt,
              style: Theme.of(context).textTheme.titleLarge,
              // textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

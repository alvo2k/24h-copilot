import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyActivitiesIllustration extends StatelessWidget {
  const EmptyActivitiesIllustration({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: Column(
        children: [
          Image.asset(
            'assets/illustrations/empty_activities.png',
          ),
          Text(
            AppLocalizations.of(context)!.tutorialPrompt,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox.shrink(),
              Image.asset(
                'assets/illustrations/arrow.png',
                width: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

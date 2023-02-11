import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../features/activities/presentation/bloc/activities_bloc.dart';
import '../features/activities/presentation/pages/activities_page.dart';
import 'injectable.dart';

class CopilotApp extends StatelessWidget {
  const CopilotApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Copilot',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (context) => ActivitiesBloc(
          loadActivitiesUsecase: sl(),
          switchActivityUsecase: sl(),
          addEmojiUsecase: sl(),
          editNameUsecase: sl(),
          insertActivityUsecase: sl(),
        )..add(ActivitiesEvent.loadActivities(DateTime.now())),
        child: const ActivitiesPage(),
      ),
    );
  }
}

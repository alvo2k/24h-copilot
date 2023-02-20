import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../core/common/bloc/theame_cubit.dart';
import '../features/activities/presentation/bloc/activities_bloc.dart';
import '../features/activities/presentation/pages/activities_page.dart';
import 'injectable.dart';

class CopilotApp extends StatefulWidget {
  const CopilotApp({Key? key}) : super(key: key);

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<CopilotApp> createState() => _CopilotAppState();
}

class _CopilotAppState extends State<CopilotApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit()..loadSavedTheme(),
        ),
        BlocProvider(
            create: (context) => ActivitiesBloc(
                  loadActivitiesUsecase: sl(),
                  switchActivityUsecase: sl(),
                  addEmojiUsecase: sl(),
                  editNameUsecase: sl(),
                  insertActivityUsecase: sl(),
                )..add(ActivitiesEvent.loadActivities(DateTime.now()))),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: CopilotApp.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Copilot',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: state,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ActivitiesPage(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/auth/presentation/widgets/login_logout_list_tile.dart';
import '../../../features/auth/presentation/widgets/user_drawer_header.dart';
import '../../layout/card_editor/card_editor.dart';
import '../bloc/theame_cubit.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  void _leaveFeedback() {
    final email = Uri(
      scheme: 'mailto',
      path: 'alvo2k@proton.me',
      queryParameters: {'subject': 'Feedback on the copilot app'},
    );
    launchUrl(email);
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserDrawerHeader(),
            const LoginLogOutListTile(),
            ListTile(
              leading: const Icon(Icons.sync),
              title: Text(AppLocalizations.of(context)!.synchronization),
              onTap: () {
                // handle synchronization logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: Text(AppLocalizations.of(context)!.editActivities),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardEditorScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: Text(AppLocalizations.of(context)!.feedback),
              onTap: _leaveFeedback,
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: Text(AppLocalizations.of(context)!.rateTheApp),
              onTap: () {
                // handle the rate the app logic
              },
            ),
            StreamBuilder(
              stream: themeCubit.stream,
              builder: (context, snapshot) {
                return ListTile(
                  leading: const Icon(Icons.brightness_6),
                  title: Text(AppLocalizations.of(context)!.theme),
                  trailing: DropdownButton<ThemeMode>(
                    value: themeCubit.state,
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(AppLocalizations.of(context)!.lightTheme),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(AppLocalizations.of(context)!.darkTheme),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(AppLocalizations.of(context)!.systemTheme),
                      ),
                    ],
                    onChanged: (ThemeMode? theme) {
                      if (theme != null) {
                        themeCubit.setTheme(theme);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

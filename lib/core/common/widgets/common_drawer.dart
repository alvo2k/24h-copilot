import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/theame_cubit.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({super.key});

  void _leaveFeedback() {
    final email = Uri(
      scheme: 'mailto',
      path: 'smith@example.com',
      queryParameters: {'subject': 'Feedback on the copilot app'},
    );
    launchUrl(email);
  }

  @override
  Widget build(BuildContext context) {
    final theameCubit = ThemeCubit();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text('Your name'),
            accountEmail: Text('email@example.com'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.loginRegistration),
            onTap: () {
              // navigate to the login/registration page
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(AppLocalizations.of(context)!.synchronization),
            onTap: () {
              // handle synchronization logic
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
            stream: theameCubit.stream,
            builder: (context, snapshot) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: Text(AppLocalizations.of(context)!.darkTheme),
                trailing: Switch(
                  value: snapshot.data == ThemeState.dark,
                  onChanged: (value) {
                    theameCubit.toggleTheme();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

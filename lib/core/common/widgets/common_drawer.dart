import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/language_cubit.dart';
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
    final languageCubit = LanguageCubit();
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
            title: const Text('Login / Registration'),
            onTap: () {
              // navigate to the login/registration page
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Synchronization'),
            onTap: () {
              // handle synchronization logic
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Leave Feedback'),
            onTap: _leaveFeedback,
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate the App'),
            onTap: () {
              // handle the rate the app logic
            },
          ),
          StreamBuilder(
            stream: theameCubit.stream,
            builder: (context, snapshot) {
              return ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text('Dark Theme'),
                trailing: Switch(
                  value: snapshot.data == ThemeState.dark,
                  onChanged: (value) {
                    theameCubit.toggleTheme();
                  },
                ),
              );
            },
          ),
          StreamBuilder(
            initialData: LanguageState.english,
            stream: languageCubit.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator.adaptive();
              }
              return ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: DropdownButton<LanguageState>(
                  value: snapshot.data as LanguageState,
                  onChanged: (value) {
                    if (value != null) {
                      languageCubit.changeLanguage(value);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: LanguageState.english,
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: LanguageState.russian,
                      child: Text('Russian'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

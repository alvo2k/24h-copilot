import 'package:category_navigator/category_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/auth_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool register = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account or Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthBloc, AuthState>(
          child: Column(
            children: [
              CategoryNavigator(
                // navigatorBackgroundColor:
                //     Theme.of(context).brightness == Brightness.light
                //         ? const Color.fromRGBO(226, 226, 226, 1)
                //         : const Color.fromARGB(255, 25, 25, 25),
                // unselectedBackgroundColor:
                //     Theme.of(context).brightness == Brightness.light
                //         ? const Color.fromRGBO(226, 226, 226, 1)
                //         : const Color.fromARGB(255, 25, 25, 25),
                expand: false,
                labels: const ['Sign In', 'Sign Up'],
                onChange: (val) {
                  setState(() {
                    if (val == 0) {
                      register = false;
                    } else {
                      register = true;
                    }
                  });
                },
              ),
              AuthForm(
                register: register,
                loading: loading,
              ),
            ],
          ),
          listener: (context, state) => state.join(
            (initial) {},
            (failure) {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: failure.message,
                ),
              );
              setState(() {
                loading = false;
              });
            },
            (load) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.info(
                  message: 'Loading...',
                ),
              );
              setState(() {
                loading = true;
              });
            },
            (loggedIn) {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.success(
                  message: 'Login successful!',
                ),
              );
              setState(() {
                loading = true;
              });
              Navigator.of(context).pop();
            },
            (loggedOut) {},
            (noInternet) => showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.info(
                message: 'No internet',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({required this.register, required this.loading, super.key});

  final bool register;
  final bool loading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController password2 = TextEditingController();

  signIn() {
    final formState = formKey.currentState;
    if (formState == null || widget.loading) return;
    if (formState.validate()) {
      if (widget.register) {
        BlocProvider.of<AuthBloc>(context)
            .add(AuthEvent.register(email.text, password.text));
      } else {
        BlocProvider.of<AuthBloc>(context)
            .add(AuthEvent.signIn(email.text, password.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: email,
            validator: (input) {
              if (input == null || input.isEmpty) {
                return 'Provide an email';
              }
              if (!EmailValidator.validate(input)) {
                return 'Invalid email';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: password,
            validator: (input) {
              if (input == null || input.length < 6) {
                return 'Password must be at least 6 long';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          widget.register
              ? TextFormField(
                  controller: password2,
                  validator: (input) {
                    if (input != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Repeat password'),
                  obscureText: true,
                )
              : const SizedBox.shrink(),
          FilledButton(
            onPressed: signIn,
            child: Text(widget.register ? "Create Account" : "Login"),
          )
        ],
      ),
    );
  }
}

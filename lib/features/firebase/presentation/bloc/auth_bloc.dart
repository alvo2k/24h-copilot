import 'package:copilot/core/error/return_types.dart';
import 'package:copilot/features/firebase/domain/usecases/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sealed_flutter_bloc/sealed_flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthUsecase usecase) : super(AuthState.initial()) {
    usecase(AuthParams());
    on<AuthEvent>((event, emit) async {
      await event.join((register) async {
        emit(AuthState.loading());
        final result = await usecase.createUser(register.email, register.pass);
        result.fold(
          (l) => emit(AuthState.failure(l.prop['message'])),
          (r) {
            r.user != null
                ? emit(AuthState.loggedIn(r.user!.email!, r.user!.displayName))
                : emit(AuthState.failure('Failed to get user data'));
          },
        );
      }, (signIn) async {
        emit(AuthState.loading());
        final result = await usecase.signIn(signIn.email, signIn.pass);
        result.fold(
          (l) => emit(AuthState.failure(l.prop['message'])),
          (r) {
            r.user != null
                ? emit(AuthState.loggedIn(r.user!.email!, r.user!.displayName))
                : emit(AuthState.failure('Failed to get user data'));
          },
        );
      }, (signOut) async {
        emit(AuthState.loading());
        await usecase.signOut();
        emit(AuthState.loggedOut());
      }, (getUserData) async {
        emit(AuthState.loading());
        final result = await usecase(AuthParams());
        result.fold((l) {
          if (l is UnsupportedPlatformFailure) {
            emit(AuthState.failure('Authentication and synchronization is not supported on this platform'));
          }
        }, (r) {
          final user = usecase.getUser();
          if (user != null) {
            emit(AuthState.loggedIn(user.email!, user.displayName));
          } else {
            emit(AuthState.loggedOut());
          }
        });
      });
    });
  }
}

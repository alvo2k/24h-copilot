import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

typedef MinutePassed = Function();

class MinuteTimerCubit extends Cubit<MinutePassed> {
  MinuteTimerCubit.startTimer() : super(() {}) {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      emit(() => () {});
    });
  }

  late Timer _timer;

  void stopTimer() {
    _timer.cancel();
  }
}

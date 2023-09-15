import 'package:flutter_bloc/flutter_bloc.dart';

import '../activity_settings.dart';

class CardEditorScreenCubit extends Cubit<ActivitySettings?> {
  CardEditorScreenCubit() : super(null);

  void onActivitySelected(ActivitySettings activity) => emit(activity);
}

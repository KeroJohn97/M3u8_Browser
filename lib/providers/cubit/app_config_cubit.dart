import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_config_state.dart';

class AppConfigCubit extends Cubit<AppConfigState> {
  AppConfigCubit() : super(AppConfigInitial());
}

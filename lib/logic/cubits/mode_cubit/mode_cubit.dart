import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mode_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeInitial());

  Brightness _mode = Brightness.light;

  Brightness get mode => _mode;

  bool get isDark => _mode == Brightness.dark;

  void toggleMode() {
    _mode = _mode == Brightness.light ? Brightness.dark : Brightness.light;
    emit(ModeInitial());
  }

  void setLightMode() {
    _mode = Brightness.light;
    emit(ModeInitial());
  }

  void setDarkMode() {
    _mode = Brightness.dark;
    emit(ModeDark());
  }
}

import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mode_state.dart';

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(ModeInitial()) {
    _loadMode();
  }

  Brightness _mode = Brightness.light;

  Brightness get mode => _mode;

  bool get isDark => _mode == Brightness.dark;

  Future<void> toggleMode() async {
    _mode = _mode == Brightness.light ? Brightness.dark : Brightness.light;
    emit(_mode == Brightness.dark ? ModeDark() : ModeInitial());
    await _saveMode();
  }

  Future<void> setLightMode() async {
    _mode = Brightness.light;
    emit(ModeInitial());
    await _saveMode();
  }

  Future<void> setDarkMode() async {
    _mode = Brightness.dark;
    emit(ModeDark());
    await _saveMode();
  }

  Future<void> _saveMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'themeMode',
      _mode == Brightness.dark ? 'dark' : 'light',
    );
  }

  Future<void> _loadMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('themeMode');
    if (themeStr == 'dark') {
      _mode = Brightness.dark;
      emit(ModeDark());
    } else {
      _mode = Brightness.light;
      emit(ModeInitial());
    }
  }
}

import 'package:flutter/material.dart';

class ModeModel extends ChangeNotifier {
  Brightness _mode = Brightness.light;

  Brightness get mode => _mode;
  

  void toggleMode() {
    _mode = _mode == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }


  void setLightMode() {
    _mode = Brightness.light;
    notifyListeners();
  }

  void setDarkMode() {
    _mode = Brightness.dark;
    notifyListeners();
  }
}

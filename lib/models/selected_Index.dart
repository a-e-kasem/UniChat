import 'package:flutter/material.dart';

class SelectedIndex extends ChangeNotifier {
  int selectedIndex = 1;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  int getSelectedIndex() {
    return selectedIndex;
  }

}
import 'package:flutter/material.dart';

class Messageregister extends ChangeNotifier {
  String? message;

  void setMessage(String message) {
    this.message = message;
    notifyListeners();
  }

  void clear() {
    message = null;
    notifyListeners();
  }
}
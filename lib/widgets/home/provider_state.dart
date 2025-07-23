import 'package:flutter/material.dart';

class ProviderState extends ChangeNotifier {

  bool join_state = false;

  void toggleJoinState() {
    join_state = !join_state;
    notifyListeners();
  }

  bool get isJoined => join_state;
}
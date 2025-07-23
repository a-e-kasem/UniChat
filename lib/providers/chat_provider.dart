import 'package:flutter/material.dart';

class ReplyProvider with ChangeNotifier {
  String? _replyMessageID;


  String? get getMessageID => _replyMessageID;

  void setReply(String id) {
    _replyMessageID = id;
    notifyListeners();
  }

  void clearReply() {
    _replyMessageID = null;
    notifyListeners();
  }
}

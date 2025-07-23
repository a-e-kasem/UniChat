import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String? _name;
  String? _email;
  String? _imageUrl;

  void setUser(User user) async {
    _name = user.displayName!.trim();
    _email = user.email!.trim();
    _imageUrl = user.photoURL;
    notifyListeners();
  }

  void setUserName(String name) {
    _name = name;
    notifyListeners();
  }

  void setUserEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setUserImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  String? get name => _name;
  String? get email => _email;
  String? get imageUrl => _imageUrl;
}

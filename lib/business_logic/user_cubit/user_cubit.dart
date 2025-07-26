import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  String? _name;
  String? _email;
  String? _imageUrl;

  void setUser(User user) async {
    _name = user.displayName!.trim();
    _email = user.email!.trim();
    _imageUrl = user.photoURL;
  }

  void setUserName(String name) {
    _name = name;
  }

  void setUserEmail(String email) {
    _email = email;
  }

  void setUserImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
  }

  String? get name => _name;
  String? get email => _email;
  String? get imageUrl => _imageUrl;
}

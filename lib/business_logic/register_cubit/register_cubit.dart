import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  String? message;

  void setMessage(String message) {
    this.message = message;
  }

  void clear() {
    message = null;
    emit(RegisterInitial());
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'swich_pages_state.dart';

class SwichPagesCubit extends Cubit<SwichPagesState> {
  SwichPagesCubit() : super(SwichPagesInitial());

  int selectedIndex = 1;

  get getSelectedIndex => selectedIndex;

  void selected(int index) {
    selectedIndex = index;
    if (index == 1) {
      emit(SwichPagesHome());
    } else if (index == 0) {
      emit(SwichPagesProfile());
    } else if (index == 2) {
      emit(SwichPagesSetting());
    }
  }
}

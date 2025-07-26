import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'replay_message_state.dart';

class ReplayMessageCubit extends Cubit<ReplayMessageState> {
  ReplayMessageCubit() : super(ReplayMessageInitial());

  String? _replyMessageID;
  String? get getMessageID => _replyMessageID;

  void setReply(String id) {
    _replyMessageID = id;
  }

  void clearReply() {
    _replyMessageID = null;
    
  }
}

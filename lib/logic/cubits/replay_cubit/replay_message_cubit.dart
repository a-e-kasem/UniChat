import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'replay_message_state.dart';

class ReplayMessageCubit extends Cubit<ReplayMessageState> {
  ReplayMessageCubit() : super(ReplayMessageInitial());

  String? _replyMessageID;
  String? get getMessageID => _replyMessageID;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  void setReply(String id) {
    _replyMessageID = id;
    emit(ReplayMessageSelected(id));
  }

  void clearReply() {
    _replyMessageID = null;
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    emit(ReplayMessageDone());
  }
}

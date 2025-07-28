part of 'replay_message_cubit.dart';

@immutable
sealed class ReplayMessageState {}

final class ReplayMessageInitial extends ReplayMessageState {}

final class ReplayMessageSelected extends ReplayMessageState {
  final String messageID;
  ReplayMessageSelected(this.messageID);
}

final class ReplayMessageDone extends ReplayMessageState {}

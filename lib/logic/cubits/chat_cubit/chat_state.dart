part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatMessageSent extends ChatState {}

class ChatImageSent extends ChatState {}

class ChatUploadingImage extends ChatState {}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

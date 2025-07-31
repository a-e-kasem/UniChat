import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:UniChat/data/services/api/cloudinary_service.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> sendMessage({
    required String groupId,
    required String text,
    String? replyMessageID,
  }) async {
    if (text.trim().isEmpty || user == null) return;

    try {
      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add({
        'senderId': user!.uid,
        'senderName': user!.displayName ?? 'Anonymous',
        'replyMessageID': replyMessageID ?? '',
        'type': 'text',
        'message': text.trim(),
        'imageUrl': '',
        'time': FieldValue.serverTimestamp(),
      });

      emit(ChatMessageSent());
    } catch (e) {
      emit(ChatError('Failed to send message.'));
    }
  }

  Future<void> sendImage({
    required String groupId,
    required ImageSource source,
    String? replyMessageID,
  }) async {
    if (user == null) return;
    emit(ChatUploadingImage());

    try {
      final imageUrl = await CloudinaryService.uploadImage(source: source);
      if (imageUrl == null) {
        emit(ChatError('Image upload failed.'));
        return;
      }

      await firestore
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add({
        'senderId': user!.uid,
        'senderName': user!.displayName ?? 'Anonymous',
        'replyMessageID': replyMessageID ?? '',
        'type': 'image',
        'message': '',
        'imageUrl': imageUrl,
        'time': FieldValue.serverTimestamp(),
      });

      emit(ChatImageSent());
    } catch (e) {
      emit(ChatError('Failed to send image.'));
    }
  }
}

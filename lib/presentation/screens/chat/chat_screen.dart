import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:UniChat/logic/replay_cubit/replay_message_cubit.dart';
import 'package:UniChat/presentation/widgets/chat/get_messages.dart';
import 'package:UniChat/data/services/api/cloudinary_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.group});

  static const String id = 'ChatScreen';
  final Map<String, dynamic> group;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _controller;
  late CollectionReference messages;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    messages = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group['groupId'])
        .collection('messages');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || user == null) return;

    final replyProvider = BlocProvider.of<ReplayMessageCubit>(context);
    final messageID = replyProvider.getMessageID;

    await messages.add({
      'senderId': user!.uid,
      'senderName': user!.displayName ?? 'Anonymous',
      'replyMessageID': messageID,
      'type': 'text',
      'message': text,
      'imageUrl': '',
      'time': FieldValue.serverTimestamp(),
    });

    
    
    replyProvider.clearReply();
    _controller.clear();
  }

  Future<void> sendImageFromSource(ImageSource source) async {
    final imageUrl = await CloudinaryService.uploadImage(source: source);
    if (imageUrl == null || user == null) return;

    final replyProvider = BlocProvider.of<ReplayMessageCubit>(context);
    final messageID = replyProvider.getMessageID;

    await messages.add({
      'senderId': user!.uid,
      'senderName': user!.displayName ?? 'Anonymous',
      'replyMessageID': messageID,
      'type': 'image',
      'message': '',
      'imageUrl': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });

    replyProvider.clearReply();
  }

  Widget buildReplyPreview(String groupId, String messageId) {
    return BlocConsumer<ReplayMessageCubit, ReplayMessageState>(
      listener: (context, state) {},
      builder: (context, state) => FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(messageId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const SizedBox();
          }

          final replyData = snapshot.data!.data() as Map<String, dynamic>;
          final replyText = replyData['type'] == 'image'
              ? '[Image]'
              : (replyData['message'] ?? '');

          return Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Replying to: $replyText',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    BlocProvider.of<ReplayMessageCubit>(context).clearReply();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                sendImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                sendImageFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          widget.group['name'] ?? 'Group Chat',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GetMessages(widget.group['groupId'], user?.uid ?? ''),
          ),
          BlocBuilder<ReplayMessageCubit, ReplayMessageState>(
            builder: (context, state) {
              if (state is ReplayMessageSelected) {
                return buildReplyPreview(
                  widget.group['groupId'],
                  state.messageID,
                );
              } else {
                return const SizedBox();
              }
            },
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                // Camera / Gallery Button
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: showImagePicker,
                  ),
                ),
                const SizedBox(width: 8),

                // Message Input
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: isDark ? Colors.grey[700] : Colors.green[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send Button
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[700] : Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

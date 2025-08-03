import 'dart:developer';

import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:UniChat/logic/cubits/replay_cubit/replay_message_cubit.dart';
import 'package:UniChat/presentation/widgets/chat/chat_input_bar.dart';
import 'package:UniChat/presentation/widgets/chat/get_messages.dart';
import 'package:UniChat/presentation/widgets/chat/member_details_screen.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.group});

  static const String id = 'ChatScreen';
  final GroupModel group;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> memberDevicesToken = [];
  String userToken = '';
  late TextEditingController _controller;
  late CollectionReference messages;
  final User? user = FirebaseAuth.instance.currentUser;
  String? role;
  final Map<String, String> userImages = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    messages = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection('messages');

    loadUserRole();
    prepareMemberTokens();
    getAllMemberImages();
    log('memberDevicesToken length: ${memberDevicesToken.length}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getAllMemberImages() async {
    try {
      for (var member in widget.group.members) {
        if (!userImages.containsKey(member.id)) {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(member.id)
              .get();

          final photoUrl = doc.data()?['photoUrl'];
          userImages[member.id] =
              photoUrl ??
              'https://i.pinimg.com/736x/0f/68/94/0f6894e539589a50809e45833c8bb6c4.jpg';
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      log('Error loading member images: $e');
    }
  }

  Future<void> prepareMemberTokens() async {
    log('Start prepareMemberTokens');
    log('widget.group.id: ${widget.group.id}');
    log('Total members: ${widget.group.members.length}');
    if (widget.group.members.isEmpty) {
      return;
    }
    memberDevicesToken.clear();
    log('Start Loop - ChatScreen');
    for (var member in widget.group.members) {
      log('member.id: ${member.id}');
      final token = member.token;
      log('token: $token');
      if (token == FirebaseApi.userToken) continue;
      memberDevicesToken.add(token);
      log('Token added: $token');
    }
  }

  Future<void> sendNotification(String message) async {
    log('sendNotification Start');
    log('memberDevicesToken length: ${memberDevicesToken.length}');
    if (memberDevicesToken.isEmpty) return;

    final serviceAccountPath = 'service-account.json';
    final projectId = 'uni-chat-69d59';
    final sender = FcmSender(serviceAccountPath, projectId);
    await sender.init();

    for (var token in memberDevicesToken) {
      log('Sending to token: $token');
      await sender.sendNotification(
        deviceToken: token,
        title: widget.group.name,
        body: message,
        data: {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
      );
      log('Notification sent to $token');
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    _controller.clear();
    if (text.isEmpty) return;

    final replyProvider = context.read<ReplayMessageCubit>();
    final replyMessageID = replyProvider.getMessageID;
    replyProvider.clearReply();

    context.read<ChatCubit>().sendMessage(
      groupId: widget.group.id,
      text: text,
      replyMessageID: replyMessageID,
    );

    await sendNotification(text);
    replyProvider.clearReply();
    _controller.clear();
  }

  void sendImageFromSource(ImageSource source) {
    final replyProvider = context.read<ReplayMessageCubit>();
    final replyMessageID = replyProvider.getMessageID;

    context.read<ChatCubit>().sendImage(
      groupId: widget.group.id,
      source: source,
      replyMessageID: replyMessageID,
    );

    replyProvider.clearReply();
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

  void showDoctorAddTools() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.poll),
              title: const Text('Create Poll'),
              onTap: () {
                Navigator.pop(context);
                // TODO:_OPEN_POLL_SCREEN
                // Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePollScreen(groupId: widget.group.id)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Upload File'),
              onTap: () {
                Navigator.pop(context);
                // TODO:_OPEN_FILE_PICKER
                // context.read<ChatCubit>().uploadFile(...);
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Send Announcement'),
              onTap: () {
                Navigator.pop(context);
                // TODO:_OPEN_ANNOUNCEMENT_SCREEN
              },
            ),
          ],
        ),
      ),
    );
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
                    context.read<ReplayMessageCubit>().clearReply();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> loadUserRole() async {
    final doc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection('members')
        .doc(user?.uid)
        .get();

    if (mounted) {
      setState(() {
        role = doc.data()?['role'];
      });
    }
  }

  bool get showImageNameOfSenderOrNotAndShowGroupMember =>
      role == 'admin' ||
      role == 'doctor' ||
      !widget.group.id.contains('courses');
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => ChatCubit(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Text(
            widget.group.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          actions: [
            showImageNameOfSenderOrNotAndShowGroupMember
                ? IconButton(
                    icon: const Icon(Icons.group),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemberDetailsScreen(
                            group: widget.group,
                            currentUserId: user?.uid ?? '',
                            currentUserRole: role ?? '',
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: GetMessages(
                chatId: widget.group.id,
                currentUserId: user?.uid ?? '',
                showImageNameOfSenderOrNot:
                    showImageNameOfSenderOrNotAndShowGroupMember,
                userImages: userImages,
              ),
            ),
            BlocBuilder<ReplayMessageCubit, ReplayMessageState>(
              builder: (context, state) {
                if (state is ReplayMessageSelected) {
                  return buildReplyPreview(widget.group.id, state.messageID);
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

                  // const SizedBox(width: 5),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: isDark ? Colors.grey[700] : Colors.green[100],
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.add),
                  //     onPressed: showDoctorAddTools,
                  //   ),
                  // ),
                  const SizedBox(width: 5),
                  Expanded(child: ChatInputBar(controller: _controller)),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.green[100],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        await sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  List<String> memberId = [];
  List<String> memberDevicesToken = [];
  String userToken = '';
  late TextEditingController _controller;
  late CollectionReference messages;
  final User? user = FirebaseAuth.instance.currentUser;
  String? role;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    messages = FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.group.id)
        .collection('messages');

    loadUserRole();
    getMemberDevicesToken();
    getMemberId();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getMemberId() {
    for (var member in widget.group.members) {
      memberId.add(member.id);
    }
  }

  void getMemberDevicesToken() async {
    for (var id in memberId) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get();
      if (id == user?.uid) {
        userToken = doc.data()?['deviceToken'];
      }
      memberDevicesToken.add(doc.data()?['deviceToken']);
    }
  }

  Future<void> sendNotification(String message) async {
    final serviceAccountPath = 'service-account.json';
    final projectId = 'uni-chat-69d59';
    final sender = FcmSender(serviceAccountPath, projectId);
    await sender.init();

    for (var memberToken in memberDevicesToken) {
      if (memberDevicesToken.contains('') || memberToken == userToken) continue;
      await sender.sendNotification(
        deviceToken: memberToken,
        title: widget.group.name,
        body: message,
        data: {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
      );
    }
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final replyProvider = context.read<ReplayMessageCubit>();
    final replyMessageID = replyProvider.getMessageID;

    await sendNotification(text);

    context.read<ChatCubit>().sendMessage(
      groupId: widget.group.id,
      text: text,
      replyMessageID: replyMessageID,
    );

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

  bool get isAdminOrDoctor => role == 'admin' || role == 'doctor';
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
            isAdminOrDoctor
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
                showNameOfSenderOrNot: isAdminOrDoctor,
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

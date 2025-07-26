import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uni_chat/presentation/widgets/admin/components/add_to_group_admin_button.dart';
import 'package:uni_chat/presentation/widgets/admin/components/delete_user_button.dart';

class UsersAdminControlScreen extends StatefulWidget {
  const UsersAdminControlScreen({super.key});
  static const String id = 'UsersAdminControlScreen';

  @override
  State<UsersAdminControlScreen> createState() => _UsersAdminControlScreenState();
}

class _UsersAdminControlScreenState extends State<UsersAdminControlScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Admin Control'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name'] ?? 'No name'),
                subtitle: Text(user['email'] ?? user['id']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DeleteUserButton(user: user),
                    const SizedBox(width: 8),
                    AddToGroupAdminButton(userId: user['id'], userName: user['name'] ?? 'Unknown User'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

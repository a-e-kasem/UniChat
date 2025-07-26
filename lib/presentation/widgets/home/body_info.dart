import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:UniChat/presentation/widgets/home/provider_state.dart';
import 'package:UniChat/presentation/screens/chat/chat_screen.dart';

class BodyInfo extends StatefulWidget {
  const BodyInfo({super.key});
  @override
  State<BodyInfo> createState() => _BodyInfoState();
}

class _BodyInfoState extends State<BodyInfo> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUserGroups() async {
    final snapshot = await firestore
        .collection('users')
        .doc(user?.uid)
        .collection('groups')
        .get();

    return snapshot.docs.map((doc) {
      return {'groupId': doc.id, 'name': doc['name']};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ProviderState>(
      builder: (context, providerState, child) =>
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getUserGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No groups found.'));
              }

              final groups = snapshot.data!;

              return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(group: group),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(FontAwesomeIcons.userGroup),
                        title: Text(
                          group['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Group ID: ${group['groupId']}'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

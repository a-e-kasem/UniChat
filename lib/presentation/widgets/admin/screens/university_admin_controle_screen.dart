import 'package:UniChat/data/core/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UniversityAdminControleScreen extends StatefulWidget {
  const UniversityAdminControleScreen({super.key});
  static const String id = 'UniversityAdminControleScreen';

  @override
  State<UniversityAdminControleScreen> createState() =>
      _UniversityAdminControleScreenState();
}

class _UniversityAdminControleScreenState
    extends State<UniversityAdminControleScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmailExample = TextEditingController();
  final TextEditingController _controllerAdminEmail = TextEditingController();

  Future<void> addUniversity(BuildContext context) async {
    final universityName = _controllerName.text.trim();
    final emailExample = _controllerEmailExample.text.trim();
    final adminEmail = _controllerAdminEmail.text.trim();

    if (universityName.isEmpty || emailExample.isEmpty || adminEmail.isEmpty) {
      showSnackBarError(context, 'All fields are required');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('universities').add({
        'name': universityName,
        'emailDomain': emailExample,
        'adminEmail': adminEmail,
        'createdAt': Timestamp.now(),
      });

      showSnackBarSuccess(context, 'University added successfully');
      _controllerName.clear();
      _controllerEmailExample.clear();
      _controllerAdminEmail.clear();
      Navigator.pop(context);
    } catch (e) {
      showSnackBarError(context, 'Error: $e');
    }
  }

  Future<List<Map<String, String>>> fetchUniversityData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .orderBy('name')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'name': data['name']?.toString() ?? '',
        'emailDomain': data['emailDomain']?.toString() ?? '',
        'adminEmail': data['adminEmail']?.toString() ?? '',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Control'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Add University'),
                  content: SizedBox(
                    width: 300,
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextField(
                          controller: _controllerName,
                          decoration: const InputDecoration(
                            labelText: 'Enter University Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: _controllerEmailExample,
                          decoration: const InputDecoration(
                            labelText: 'Enter email domain (e.g., @su.edu.eg)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        TextField(
                          controller: _controllerAdminEmail,
                          decoration: const InputDecoration(
                            labelText: 'Enter administration email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _controllerName.clear();
                        _controllerEmailExample.clear();
                        _controllerAdminEmail.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => addUniversity(context),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Participating Universities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Map<String, String>>>(
            future: fetchUniversityData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: \${snapshot.error}'));
              }

              final universities = snapshot.data!;
              if (universities.isEmpty) {
                return const Text('No universities found.');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: universities.map((uni) {
                  return ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(uni['name']!),
                    subtitle: Text(
                      '${uni['emailDomain']} | Admin: ${uni['adminEmail']}',
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowUsersFromUniversityScreen extends StatefulWidget {
  const ShowUsersFromUniversityScreen({super.key, required this.emailDomain});
  final String emailDomain;

  @override
  State<ShowUsersFromUniversityScreen> createState() =>
      _ShowUsersFromUniversityScreenState();
}

class _ShowUsersFromUniversityScreenState
    extends State<ShowUsersFromUniversityScreen> {
  List<Map<String, String>> allUsers = [];
  List<Map<String, String>> toFilter = [];

  String selectedYear = '1st year';
  final List<String> yearsOfStudy = [
    '1st year',
    '2nd year',
    '3rd year',
    '4th year',
  ];

  @override
  void initState() {
    super.initState();
    getUsersFromEmailDomain();
  }

  Future<void> getUsersFromEmailDomain() async {
    log('start get data');

    final snapshot = await FirebaseFirestore.instance.collection('users').get();

    final filtered = snapshot.docs.where((doc) {
      final email = doc['email']?.toString() ?? '';
      return email.endsWith('@${widget.emailDomain}.edu.eg');
    }).toList();

    final users = filtered.map((doc) {
      final data = doc.data();
      return {
        'name': data['name']?.toString() ?? data['uid']?.toString() ?? '',
        'uid': data['uid']?.toString() ?? '',
        'email': data['email']?.toString() ?? '',
      };
    }).toList();

    setState(() {
      allUsers = users;
      toFilter = users;
    });

    log('end get data');
  }

  void applyFilter() {
    final selectedIndex = int.parse(selectedYear[0]);
    final currentYear = DateTime.now().year;

    final filtered = allUsers.where((user) {
      final uid = user['uid']!;
      final yearOfJoin = int.tryParse(uid.substring(0, 4)) ?? currentYear;
      final studyYear = (currentYear - yearOfJoin + 1).clamp(1, 4);
      return studyYear == selectedIndex;
    }).toList();

    setState(() {
      toFilter = filtered;
    });
  }

  void clearFilter() {
    setState(() {
      selectedYear = '1st year';
      toFilter = allUsers;
    });
  }

  void copyEmailsToClipboard() {
    final emails = toFilter.map((user) => user['email']).join('\n');
    Clipboard.setData(ClipboardData(text: emails));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Emails copied to clipboard')));
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filter Users'),
        content: SizedBox(
          width: double.maxFinite,
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedYear,
            items: yearsOfStudy.map((year) {
              return DropdownMenuItem<String>(value: year, child: Text(year));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedYear = value;
                });
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              applyFilter();
            },
            child: const Text('Filter Users'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              copyEmailsToClipboard();
            },
            child: const Text('Copy Emails'),
          ),
        ],
      ),
    );
  }

  Widget buildUserTile(Map<String, String> user) {
    return ListTile(
      title: Text(user['name'] ?? ''),
      subtitle: Text(user['email'] ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    log('start build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users from University'),
        actions: [
          GestureDetector(
            onTap: () {
              clearFilter();
            },
            child: const Icon(Icons.filter_alt_off_sharp),
          ),
          GestureDetector(
            onTap: () {
              showFilterDialog();
            },
            child: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: toFilter.isEmpty
          ? const Center(child: Text('No users found.'))
          : ListView.builder(
              itemCount: toFilter.length,
              itemBuilder: (context, index) => buildUserTile(toFilter[index]),
            ),
    );
  }
}

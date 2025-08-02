import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowSupportMessageScreen extends StatefulWidget {
  const ShowSupportMessageScreen({super.key});

  @override
  State<ShowSupportMessageScreen> createState() =>
      _ShowSupportMessageScreenState();
}

class _ShowSupportMessageScreenState extends State<ShowSupportMessageScreen> {
  List<String> supportMessages = [];

  @override
  void initState() {
    super.initState();
    getSupportMessages();
  }

  Future<void> getSupportMessages() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('supportMessage')
        .get();
    setState(() {
      supportMessages = snapshot.docs
          .map((doc) => doc.data()['message'] as String)
          .toList();
    });
  }

  bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Support Message',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
           
            const SizedBox(height: 20),
            Expanded(
              child: supportMessages.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: supportMessages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: Theme.of(context).cardColor,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        supportMessages[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textDirection:
                                            isArabic(supportMessages[index])
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },

                            child: Text(
                              supportMessages[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textDirection: isArabic(supportMessages[index])
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

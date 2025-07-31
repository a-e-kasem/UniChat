import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UniversitySelector extends StatefulWidget {
  const UniversitySelector({super.key, required this.universityDomain});
  final TextEditingController universityDomain;
  @override
  State<UniversitySelector> createState() => _UniversitySelectorState();
}

class _UniversitySelectorState extends State<UniversitySelector> {
  String? selectedUniversity;
  Map<String, String> universityMap = {};

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('universities')
        .orderBy('name')
        .get();

    setState(() {
      universityMap = {
        for (var doc in snapshot.docs)
          doc['name'].toString(): doc['emailDomain'].toString(),
      };

      if (widget.universityDomain.text.isNotEmpty) {
        selectedUniversity = universityMap.keys.firstWhere(
          (name) => universityMap[name] == widget.universityDomain.text,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'University:',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            hint: const Text('Select your university'),
            value: selectedUniversity,
            items: universityMap.entries.map((entry) {
              return DropdownMenuItem(
                value: entry.value,
                child: Text(entry.key),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedUniversity = value!;
                widget.universityDomain.text = value;
              });
              log(value.toString());
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your university';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

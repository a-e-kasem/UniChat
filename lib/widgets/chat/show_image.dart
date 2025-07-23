

import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.imageUrl});
  static const String id = 'ShowImage';
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Image Preview'),
        centerTitle: true,
      ),
      body: Center(
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';

class ResultPreview extends StatelessWidget {
  final File originalImage;
  final File? processedImage;

  const ResultPreview({
    super.key,
    required this.originalImage,
    this.processedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Original",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Image.file(originalImage, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Processed",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: processedImage != null
                      ? Image.file(processedImage!, fit: BoxFit.contain)
                      : const Center(
                          child: Text(
                            "No result yet",
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14),
                          ),
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

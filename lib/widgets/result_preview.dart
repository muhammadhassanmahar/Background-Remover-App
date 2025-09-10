import 'dart:io' show File;
import 'package:flutter/foundation.dart'; // ✅ for kIsWeb & Uint8List
import 'package:flutter/material.dart';

class ResultPreview extends StatelessWidget {
  final dynamic originalImage; // ✅ Can be File (mobile) or Uint8List (web)
  final Uint8List? processedImage;

  const ResultPreview({
    super.key,
    required this.originalImage,
    this.processedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                child: _buildOriginalPreview(), // ✅ use safe method
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
                    ? Image.memory(processedImage!, fit: BoxFit.contain)
                    : const Center(
                        child: Text(
                          "No result yet",
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOriginalPreview() {
    if (kIsWeb) {
      // ✅ On Web: always Uint8List
      return Image.memory(originalImage as Uint8List, fit: BoxFit.contain);
    } else {
      // ✅ On Mobile: always File
      return Image.file(originalImage as File, fit: BoxFit.contain);
    }
  }
}

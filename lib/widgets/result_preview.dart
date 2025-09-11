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
        // ✅ Original Image Section
        Expanded(
          child: Column(
            children: [
              const Text(
                "Original",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: _buildOriginalPreview(),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ✅ Processed Image Section
        Expanded(
          child: Column(
            children: [
              const Text(
                "Processed",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: processedImage != null
                      ? Image.memory(
                          processedImage!,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text(
                              "⚠ Error loading image",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 14),
                            ),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No result yet",
                            style: TextStyle(
                                color: Colors.white38, fontSize: 14),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ✅ Safe method to build original image preview
  Widget _buildOriginalPreview() {
    try {
      if (kIsWeb) {
        // Web → Uint8List
        return Image.memory(
          originalImage as Uint8List,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
            child: Text(
              "⚠ Invalid image",
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
        );
      } else {
        // Mobile/Desktop → File
        return Image.file(
          originalImage as File,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
            child: Text(
              "⚠ Invalid file",
              style: TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
        );
      }
    } catch (_) {
      return const Center(
        child: Text(
          "⚠ Preview not available",
          style: TextStyle(color: Colors.redAccent, fontSize: 14),
        ),
      );
    }
  }
}

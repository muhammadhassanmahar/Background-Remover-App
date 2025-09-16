import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // kIsWeb + Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/api_service.dart';
import '../utills/app_colors.dart';
import '../widgets/image_picker_buttons.dart';
import '../widgets/result_preview.dart';

// ✅ Web ke liye hi import karo
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html
    show Blob, Url, AnchorElement; // Safe for web only

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() =>
      _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen> {
  dynamic _selectedImage; // File (mobile) ya Uint8List (web)
  Uint8List? _outputImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  /// ✅ Pick image from gallery
  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final img = kIsWeb ? await picked.readAsBytes() : File(picked.path);
      setState(() {
        _selectedImage = img;
        _outputImage = null;
      });
    }
  }

  /// ✅ Pick image from camera
  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      final img = kIsWeb ? await picked.readAsBytes() : File(picked.path);
      setState(() {
        _selectedImage = img;
        _outputImage = null;
      });
    }
  }

  /// ✅ Call API to remove background
  Future<void> _removeBackground() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.removeBackground(
        imageFilePath:
            !kIsWeb && _selectedImage is File ? _selectedImage.path : null,
        imageBytes:
            kIsWeb && _selectedImage is Uint8List ? _selectedImage : null,
      );

      if (!mounted) return;

      setState(() {
        _outputImage = result;
        _isLoading = false;
      });

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Failed to remove background")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠ Error: $e")),
      );
    }
  }

  /// ✅ Save image (Mobile/Desktop) or Download (Web)
  Future<void> _saveImage() async {
    if (_outputImage == null) return;

    if (kIsWeb) {
      // Web → download
      final blob = html.Blob([_outputImage!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..download = "background_removed.png"
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop → save to storage
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/background_removed.png");
        await file.writeAsBytes(_outputImage!);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Saved to: ${file.path}")),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠ Storage permission denied")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Background Remover"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ Image Preview
              Expanded(
                child: _selectedImage != null
                    ? ResultPreview(
                        originalImage: _selectedImage,
                        processedImage: _outputImage,
                      )
                    : const Center(
                        child: Text(
                          "📷 Select an image to remove background",
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 16,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // ✅ Camera + Gallery Buttons
              ImagePickerButtons(
                onCameraTap: _pickFromCamera,
                onGalleryTap: _pickFromGallery,
              ),

              const SizedBox(height: 16),

              // ✅ Action Buttons (Remove BG + Download)
              Row(
                children: [
                  // Remove BG Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (_selectedImage != null && !_isLoading)
                          ? _removeBackground
                          : null,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_fix_high, color: Colors.white),
                      label: Text(
                        _isLoading ? "Processing..." : "Remove BG",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Download/Save Button
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _outputImage != null ? _saveImage : null,
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        "Download",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

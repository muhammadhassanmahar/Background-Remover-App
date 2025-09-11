import 'dart:io' show File;
import 'package:flutter/foundation.dart'; // ✅ For kIsWeb & Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/result_preview.dart';
import '../widgets/image_picker_buttons.dart';

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() =>
      _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen> {
  File? _selectedImageFile; // ✅ For mobile/desktop
  Uint8List? _selectedImageBytes; // ✅ For web
  Uint8List? _processedImage; // ✅ API result
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  /// ✅ Pick image from [source] (camera/gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        if (kIsWeb) {
          // Web → read bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImageFile = null;
            _processedImage = null;
          });
        } else {
          // Mobile/Desktop → File path
          setState(() {
            _selectedImageFile = File(pickedFile.path);
            _selectedImageBytes = null;
            _processedImage = null;
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image selection failed: $e")),
      );
    }
  }

  /// ✅ Call API to remove background
  Future<void> _removeBackground() async {
    if (_selectedImageFile == null && _selectedImageBytes == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.removeBackground(
        imageFilePath: _selectedImageFile?.path,
        imageBytes: _selectedImageBytes,
      );

      if (!mounted) return;

      if (result != null) {
        setState(() => _processedImage = result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Background removal failed.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _selectedImageFile != null || _selectedImageBytes != null;

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("AI Background Remover"),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ Image Preview
              Expanded(
                child: hasImage
                    ? ResultPreview(
                        originalImage: _selectedImageFile ??
                            _selectedImageBytes!, // handles both
                        processedImage: _processedImage,
                      )
                    : const Center(
                        child: Text(
                          "📷 Select an image to begin",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
              ),

              // ✅ Loader
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(color: Colors.white),
                ),

              const SizedBox(height: 20),

              // ✅ Camera + Gallery Buttons
              ImagePickerButtons(
                onCameraTap: () => _pickImage(ImageSource.camera),
                onGalleryTap: () => _pickImage(ImageSource.gallery),
              ),

              const SizedBox(height: 20),

              // ✅ Remove BG Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400],
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 30,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: hasImage && !_isLoading ? _removeBackground : null,
                child: const Text(
                  "✨ Remove Background",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../widgets/result_preview.dart';
import '../widgets/image_picker_buttons.dart';

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() => _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen> {
  File? _selectedImage;
  Uint8List? _processedImage; // ✅ changed from File? to Uint8List?
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _removeBackground() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final result = await ApiService.removeBackground(_selectedImage!);

    setState(() {
      _processedImage = result; // ✅ now Uint8List works fine
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("Remove Background"),
        backgroundColor: Colors.blueGrey[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_selectedImage != null)
              ResultPreview(
                originalImage: _selectedImage!,
                processedImage: _processedImage, // ✅ Uint8List? pass
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    "Select an image to begin",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            const SizedBox(height: 20),
            ImagePickerButtons(
              onCameraTap: () => _pickImage(ImageSource.camera),
              onGalleryTap: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[400],
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _selectedImage != null ? _removeBackground : null,
              child: const Text(
                "Remove Background",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

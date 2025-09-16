import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class BackgroundRemoverScreen extends StatefulWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  State<BackgroundRemoverScreen> createState() => _BackgroundRemoverScreenState();
}

class _BackgroundRemoverScreenState extends State<BackgroundRemoverScreen> {
  File? _selectedImage;
  Uint8List? _outputImage;
  bool _isLoading = false;

  /// Pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        _outputImage = null; // reset old result
      });
    }
  }

  /// Remove background using API
  Future<void> _removeBackground() async {
    if (_selectedImage == null) return;

    setState(() => _isLoading = true);

    final result = await ApiService.removeBackground(_selectedImage!);

    if (!mounted) return; // 👈 fixes use_build_context_synchronously

    setState(() {
      _outputImage = result;
      _isLoading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove background")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("Background Remover"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Show selected or output image
            Expanded(
              child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : _outputImage != null
                        ? Image.memory(_outputImage!)
                        : _selectedImage != null
                            ? Image.file(_selectedImage!)
                            : const Text(
                                "📷 Select an image to remove background",
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Image"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  onPressed: _selectedImage != null ? _removeBackground : null,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text("Remove BG"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

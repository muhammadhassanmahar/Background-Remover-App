import 'package:flutter/material.dart';
import 'background_remover_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("AI Background Remover"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 100,
                  color: Colors.white70,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Remove background from any image instantly with AI ✨",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BackgroundRemoverScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "🚀 Start Removing",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

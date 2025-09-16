import 'package:flutter/material.dart';

class BackgroundRemoverScreen extends StatelessWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("Background Remover"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800],
      ),
      body: const Center(
        child: Text(
          "📷 Background remover will be here soon!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/background_remover_screen.dart';

void main() {
  // ✅ Error screen enable karo
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "⚠️ Error: ${details.exceptionAsString()}",
            style: const TextStyle(color: Colors.red, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Background Remover',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xfff5f5f5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/background-remover': (context) => const BackgroundRemoverScreen(),
      },
    );
  }
}

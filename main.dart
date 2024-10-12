import 'package:flutter/material.dart';
import 'image_picker_screen.dart';
import 'process_image_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Extractor',
      initialRoute: '/',
      routes: {
        '/': (context) => ImagePickerScreen(),
        '/process': (context) {
          final String imagePath =
              ModalRoute.of(context)!.settings.arguments as String;
          return ProcessImageScreen(imagePath: imagePath);
        },
      },
    );
  }
}

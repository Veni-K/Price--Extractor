import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ProcessImageScreen extends StatefulWidget {
  final String imagePath;

  const ProcessImageScreen({super.key, required this.imagePath});

  @override
  _ProcessImageScreenState createState() => _ProcessImageScreenState();
}

class _ProcessImageScreenState extends State<ProcessImageScreen> {
  String? extractedPrice;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    try {
      final inputImage = InputImage.fromFilePath(widget.imagePath);
      // ignore: deprecated_member_use
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      // Recognize text in the image

      // Extract prices

      var recognizedText;
      final prices = _extractPrices(recognizedText.text);

      // Save prices to a file
      await _savePricesToFile(prices);

      setState(() {
        extractedPrice =
            prices.isNotEmpty ? prices.join(', ') : 'No prices found';
      });

      // Close the recognizer after use to avoid memory leaks
      await textRecognizer.close();
    } catch (e) {
      print('Error processing image: $e');
      setState(() {
        extractedPrice = 'Error occurred';
      });
    }
  }

  List<String> _extractPrices(String text) {
    // Regular expression for detecting prices in the format of $, £, €
    RegExp exp = RegExp(r'(?<=\$|£|€)\s*\d+(\.\d{1,2})?');
    return exp.allMatches(text).map((match) => match.group(0)!).toList();
  }

  Future<void> _savePricesToFile(List<String> prices) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/prices.txt');
      final buffer = StringBuffer();

      for (var price in prices) {
        buffer.writeln('${widget.imagePath.split('/').last} $price');
      }

      await file.writeAsString(buffer.toString());
    } catch (e) {
      print('Error saving prices to file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Processed Image')),
      body: Center(
        child: Text(extractedPrice ?? 'Processing...'),
      ),
    );
  }
}

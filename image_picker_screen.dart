import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  ImagePickerScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Process the selected image
      Navigator.pushNamed(context, '/process', arguments: image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Image')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _pickImage(context),
          child: const Text('Pick Image from Gallery'),
        ),
      ),
    );
  }
}

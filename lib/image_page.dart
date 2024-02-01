import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({super.key});

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Widget _selectedImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Colors.black,
      child: Center(
        child: (selectedImage == null)
            ? const Icon(
                Icons.image_not_supported,
                color: Colors.white,
                size: 100,
              )
            : Image.file(
                selectedImage!,
                fit: BoxFit.fill,
              ),
      ),
    );
  }

  Widget _imageGallery() {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 1.0, crossAxisSpacing: 1.0, crossAxisCount: 3),
        itemCount: 10,
        itemBuilder: (context, index) => Container(
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.check)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _selectedImage(), //이미지가 선택되면 이미지를 보여줌
            _imageGallery(),
          ],
        ),
      ),
    );
  }
}

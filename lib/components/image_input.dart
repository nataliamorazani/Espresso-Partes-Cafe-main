import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function(File) onSelectImage;
  final String selectedImage;
  const ImageInput(
    this.onSelectImage, {
    Key? key,
    required this.selectedImage,
  }) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  @override
  initState() {
    super.initState();
    _storedImage =
        widget.selectedImage.trim() != "" ? File(widget.selectedImage) : null;
  }

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy(
      '${appDir.path}/$fileName',
    );
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _takePicture,
      child: Container(
        height: 200,
        decoration: const BoxDecoration(color: Colors.white),
        alignment: Alignment.center,
        child: _storedImage != null
            ? Image.file(
                _storedImage!,
                width: double.infinity,
                fit: BoxFit.contain,
              )
            : const Text('Nenhuma imagem!'),
      ),
    );
  }
}

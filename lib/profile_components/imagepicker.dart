import 'package:flutter/material.dart';
import 'dart:io';

class ProfileImagePicker extends StatelessWidget {
  final File? image;
  final VoidCallback onPickImage;

  const ProfileImagePicker({
    super.key,
    required this.image,
    required this.onPickImage,
    String? imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundImage: image != null ? FileImage(image!) : null,
          child:
              image == null
                  ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                  : null,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FileUploadButton extends StatelessWidget {
  final VoidCallback onPickFile;
  final String? fileName;

  const FileUploadButton({super.key, required this.onPickFile, this.fileName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Resume",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: onPickFile,
          icon: const Icon(Icons.upload_file),
          label: const Text("Upload Resume"),
        ),
        if (fileName != null) Text("Resume uploaded: $fileName"),
      ],
    );
  }
}

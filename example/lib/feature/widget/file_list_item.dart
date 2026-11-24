import 'dart:io';

import 'package:flutter/material.dart';

class FileListItem extends StatelessWidget {
  final File file;
  final VoidCallback onPressed;

  const FileListItem({
    super.key,
    required this.file,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(
            10,
          ),
          child: Text(
            file.path.split('/').last,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

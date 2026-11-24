import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../entities/denied_permission_settings_dialog_model.dart';

class FilePickerUtil {
  /// Picks local files through the platform's system picker.
  ///
  /// The picker grants access to the selected files. Returns null on cancellation
  /// or when the selection has no local paths.
  Future<List<File>?> getFilePicker({
    /// context
    required BuildContext context,

    /// [permissionDescriptionText] provide description text which describe that permission requirement
    String? permissionDescriptionText,

    /// default [fileType] is [FileType.any], you can pass [fileType] as per your requirement
    FileType fileType = FileType.any,

    /// [allowedExtensions] pass array of allowedExtensions
    List<String>? allowedExtensions,

    /// Retained for callers using the previous picker interface.
    @Deprecated('Set compressionQuality to enable media compression.')
    bool allowCompression = false,

    /// Media compression quality from 1 to 100, or 0 to keep the original.
    int compressionQuality = 0,

    /// [allowMultiple] pass bool value for allowMultiple
    bool allowMultiple = false,

    /// Using [deniedPermissionsSettingsDialogModel] we can able to customize denied permission dialog style and content
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    final List<PlatformFile> selection;
    if (allowMultiple) {
      selection = await FilePicker.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        compressionQuality: compressionQuality,
      );
    } else {
      final file = await FilePicker.pickFile(
        type: fileType,
        allowedExtensions: allowedExtensions,
        compressionQuality: compressionQuality,
      );
      selection = [?file];
    }

    final files = [
      for (final file in selection)
        if (file.path case final path? when path.isNotEmpty) File(path),
    ];
    return files.isEmpty ? null : files;
  }
}

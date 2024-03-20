import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';

class FilePickerUtil {
  /// pick single or multiple file using this method with permission handling
  Future<List<File>?> getFilePicker({
    /// context
    required BuildContext context,

    /// [permissionDescriptionText] provide description text which describe that permission requirement
    String? permissionDescriptionText,

    /// default [fileType] is [FileType.any], you can pass [fileType] as per your requirement
    FileType fileType = FileType.any,

    /// [allowedExtensions] pass array of allowedExtensions
    List<String>? allowedExtensions,

    /// [allowCompression] pass bool value for compression
    bool allowCompression = false,

    /// [allowMultiple] pass bool value for allowMultiple
    bool allowMultiple = false,

    /// Using [deniedPermissionsSettingsDialogModel] we can able to customize denied permission dialog style and content
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    if (await PermissionHandler().getStoragePermission(
      context: context,
      deniedPermissionsSettingsDialogModel:
          deniedPermissionsSettingsDialogModel,
      permissionDescriptionText:
          permissionDescriptionText ?? "Permission is required to access files",
    )) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        allowMultiple: allowMultiple,
      );
      if (result != null && result.files.isNotEmpty) {
        List<File> pickedFileList =
            result.files.map((e) => File(e.path!)).toList();
        return pickedFileList;
      } else {
        return null;
      }
    }
    return null;
  }
}

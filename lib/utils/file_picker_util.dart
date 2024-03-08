
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/utils/permission_util.dart';

import '../widgets/custom_alert_with_two_buttons.dart';

class FilePickerUtil{

   Future<List<File>?> getFilePicker({
    required BuildContext context,
     String? permissionDescriptionText,
     FileType fileType = FileType.any,
     List<String>? allowedExtensions,
     bool allowCompression = false,
     bool allowMultiple = false,
     DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,

   }) async {
    if (await PermissionUtil.getStoragePermission(
        context: context,
      deniedPermissionsSettingsDialogModel: deniedPermissionsSettingsDialogModel,
      permissionDescriptionText: permissionDescriptionText??"Permission is required to access files"
      )) {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType??FileType.any,
        allowedExtensions: allowedExtensions,
        allowCompression: allowCompression,
        allowMultiple: allowMultiple
      );
      if(result != null && result.files.isNotEmpty){
        List<File> pickedFileList = result.files.map((e) => File(e.path!)).toList();
        return pickedFileList ;
      }else{
        return null ;
      }
    }
    return null;
  }

}
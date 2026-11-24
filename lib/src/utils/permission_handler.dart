import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  /// This permission is use for the access the device storage
  Future<bool> getStoragePermission({
    /// pass the BuildContext
    required BuildContext context,

    /// [permissionDescriptionText] pass String value for permanently denied storage permission dialog description
    required String permissionDescriptionText,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        return true;
      }
    }

    final status = await Permission.storage.request();
    if (status.isGranted) return true;
    if (!context.mounted) return false;

    if ((Platform.isAndroid &&
            (status.isPermanentlyDenied || status.isRestricted)) ||
        (Platform.isIOS && (status.isDenied || status.isRestricted))) {
      customDialog(
        context: context,
        deniedPermissionsSettingsDialogModel:
            deniedPermissionsSettingsDialogModel,
        permissionDescriptionText: permissionDescriptionText,
      );
    }
    return false;
  }

  /// This permission is use for the access the camera
  Future<bool> getCameraPermission({
    /// pass the BuildContext
    required BuildContext context,

    /// [permissionDescriptionText] pass String value for permanently denied camera permission dialog description
    required String permissionDescriptionText,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    PermissionStatus status = await Permission.camera.request();
    if (!context.mounted) return status.isGranted;
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.denied) {
      return false;
    } else {
      if ((Platform.isAndroid &&
              status == PermissionStatus.permanentlyDenied) ||
          (Platform.isIOS &&
              (status == PermissionStatus.restricted ||
                  status == PermissionStatus.permanentlyDenied))) {
        customDialog(
          context: context,
          permissionDescriptionText: permissionDescriptionText,
          deniedPermissionsSettingsDialogModel:
              deniedPermissionsSettingsDialogModel,
        );
        return false;
      } else {
        return false;
      }
    }
  }

  /// This permission is use for the access the photos (For ios only)
  Future<bool> getPhotosPermission({
    /// pass the BuildContext
    required BuildContext context,

    /// [permissionDescriptionText] pass String value for permanently denied photo permission dialog description
    required String permissionDescriptionText,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    PermissionStatus status = await Permission.photos.request();
    if (!context.mounted) return status.isGranted || status.isLimited;
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) {
      return true;
    } else if (status == PermissionStatus.denied) {
      return false;
    } else {
      if (status == PermissionStatus.restricted ||
          status == PermissionStatus.permanentlyDenied) {
        customDialog(
          context: context,
          permissionDescriptionText: permissionDescriptionText,
          deniedPermissionsSettingsDialogModel:
              deniedPermissionsSettingsDialogModel,
        );
        return false;
      } else {
        return false;
      }
    }
  }

  /// custom dialog to show permanently denied permission dialog and device settings navigation
  void customDialog({
    /// pass the BuildContext
    required BuildContext context,

    /// [permissionDescriptionText] pass String value for permanently denied permission dialog description
    required String permissionDescriptionText,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 10),
                  color: Theme.of(context).shadowColor,
                  blurRadius: 24.0,
                ),
              ],
            ),
            child: CustomAlertWithTwoButtons(
              titleText:
                  deniedPermissionsSettingsDialogModel?.titleText ??
                  'Permission Required',
              descriptionText: permissionDescriptionText,
              negativeButtonText:
                  deniedPermissionsSettingsDialogModel?.negativeButtonText ??
                  "Close",
              settingsButtonText:
                  deniedPermissionsSettingsDialogModel?.settingsButtonText ??
                  'Go To Settings',
            ),
          ),
        );
      },
    );
  }

  /// open settings to enable permission for android and IOS
  Future<void> openSettings() async {
    await openAppSettings();
  }
}

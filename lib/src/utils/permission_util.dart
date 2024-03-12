import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> getStoragePermission({
    required BuildContext context,
    required String permissionDescriptionText,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    PermissionStatus? status;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      status = androidInfo.version.sdkInt >= 33
          ? await Permission.photos.request()
          : await Permission.storage.request();
    } else {
      status = await Permission.storage.request();
    }
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      if (Platform.isAndroid) {
        if (status == PermissionStatus.permanentlyDenied ||
            status.isRestricted) {
          customDialog(
              context: context,
              deniedPermissionsSettingsDialogModel:
                  deniedPermissionsSettingsDialogModel,
              permissionDescriptionText: permissionDescriptionText);
          return false;
        } else {
          return false;
        }
      } else if (Platform.isIOS) {
        Permission.storage.request().then(
          (status) async {
            if (status == PermissionStatus.denied ||
                status == PermissionStatus.restricted) {
              customDialog(
                context: context,
                deniedPermissionsSettingsDialogModel:
                    deniedPermissionsSettingsDialogModel,
                permissionDescriptionText: permissionDescriptionText,
              );
              return false;
            } else {
              return false;
            }
          },
        );
      }
    }
    return false;
  }

  /// This permission is use for the access the camera
  static Future<bool> getCameraPermission({
    required BuildContext context,
    required String permissionDescriptionText,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    PermissionStatus status = await Permission.camera.request();
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
  static Future<bool> getPhotosPermission({
    required BuildContext context,
    required String permissionDescriptionText,
    required DeniedPermissionsSettingsDialogModel?
        deniedPermissionsSettingsDialogModel,
  }) async {
    PermissionStatus status = await Permission.photos.request();
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

  static customDialog({
    required BuildContext context,
    required String permissionDescriptionText,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(
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
                    offset: Offset(
                      0,
                      10,
                    ),
                    color: Theme.of(context).shadowColor,
                    blurRadius: 24.0,
                  ),
                ],
              ),
              child: CustomAlertWithTwoButtons(
                titleText: deniedPermissionsSettingsDialogModel?.titleText ??
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
        });
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}

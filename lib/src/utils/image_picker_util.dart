import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  Future<void> showImagePickerBottomSheet({
    context,
    String? bottomSheetTitle,
    String? cameraTitle,
    String? galleryTitle,
    String? cameraPermissionDescriptionText,
    String? galleryPermissionDescriptionText,
    bool isCropImage = false,
    TextStyle? bottomSheetTitleStyle,
    TextStyle? cameraTitleStyle,
    TextStyle? galleryTitleStyle,
    EdgeInsetsGeometry? bottomSheetInternalPadding,
    EdgeInsetsGeometry? bottomSheetItemPadding,
    EdgeInsetsGeometry? bottomSheetTitlePadding,
    List<PlatformUiSettings>? cropImagePlatformUiSettings,
    List<CropAspectRatioPreset>? cropImageAspectRatioPresets,
    int? cropImageMaxWidth,
    int? cropImageMaxHeight,
    int? pickImageImageQuality,
    ShapeBorder? bottomSheetShape,
    bool savePickedCameraImageToStorage = false,
    required Function(File? file) onImageSelection,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
  }) async {
    /// bottomSheet for image picker option
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: bottomSheetShape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
        builder: (BuildContext _) => Wrap(
              children: [
                Container(
                  color: Colors.transparent,
                  padding: bottomSheetInternalPadding ??
                      const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 20,
                        bottom: 15,
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 5,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: bottomSheetTitlePadding ??
                            const EdgeInsets.only(
                                left: 0, right: 0, top: 15, bottom: 15),
                        child: Text(
                          bottomSheetTitle ?? "Pick image",
                          style: bottomSheetTitleStyle ??
                              Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        color: Theme.of(context).dividerColor,
                        height: 1,
                      ),
                      Wrap(
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              /// handle camera permission
                              File? file = await getFromCameraWithPermissionCheck(
                                  context: context,
                                  deniedPermissionsSettingsDialogModel:
                                      deniedPermissionsSettingsDialogModel,
                                  permissionDescriptionText:
                                      cameraPermissionDescriptionText ??
                                          "Permission required to access camera",
                                  isCrop: isCropImage,
                                  uiSettings: cropImagePlatformUiSettings,
                                  aspectRatioPresets:
                                      cropImageAspectRatioPresets,
                                  saveCameraImage:
                                      savePickedCameraImageToStorage);
                              onImageSelection(file);
                              if (file != null) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: bottomSheetItemPadding ??
                                  const EdgeInsets.only(
                                      left: 0, right: 0, top: 15, bottom: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    cameraTitle ?? "Choose from camera",
                                    style: cameraTitleStyle ??
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              color: Theme.of(context).dividerColor, height: 1),
                          InkWell(
                            onTap: () async {
                              File? file = await getFromGalleryWithPermissionCheck(
                                  context: context,
                                  deniedPermissionsSettingsDialogModel:
                                      deniedPermissionsSettingsDialogModel,
                                  permissionDescriptionText:
                                      galleryPermissionDescriptionText ??
                                          'Permission required to access gallery',
                                  isCrop: isCropImage,
                                  uiSettings: cropImagePlatformUiSettings,
                                  aspectRatioPresets:
                                      cropImageAspectRatioPresets);
                              onImageSelection(file);
                              if (file != null) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: bottomSheetItemPadding ??
                                  const EdgeInsets.only(
                                    left: 0,
                                    right: 0,
                                    top: 15,
                                    bottom: 15,
                                  ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    galleryTitle ?? "Choose from gallery",
                                    style: galleryTitleStyle ??
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  /// below method is for image cropping, customise as per your usage
  Future<File?> cropImage({
    required File file,
    required BuildContext context,
    List<PlatformUiSettings>? uiSettings,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    int? cropImageMaxWidth,
    int? cropImageMaxHeight,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      maxHeight: cropImageMaxHeight,
      maxWidth: cropImageMaxWidth,
      sourcePath: file.path,
      aspectRatioPresets: aspectRatioPresets ??
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
      uiSettings: uiSettings ??
          [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
                toolbarWidgetColor: Theme.of(context).iconTheme.color,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<File?> getFromGalleryWithPermissionCheck({
    required BuildContext context,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
    required String permissionDescriptionText,
    List<PlatformUiSettings>? uiSettings,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    double? pickImageMaxWidth,
    double? pickImageMaxHeight,
    int? pickImageImageQuality,
    bool isCrop = false,
    int? cropImageMaxWidth,
    int? cropImageMaxHeight,
  }) async {
    if (Platform.isAndroid
        ? await PermissionHandler().getStoragePermission(
            context: context,
            deniedPermissionsSettingsDialogModel:
                deniedPermissionsSettingsDialogModel,
            permissionDescriptionText: permissionDescriptionText,
          )
        : await PermissionHandler().getPhotosPermission(
            context: context,
            deniedPermissionsSettingsDialogModel:
                deniedPermissionsSettingsDialogModel,
            permissionDescriptionText: permissionDescriptionText)) {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: pickImageMaxWidth,
        maxHeight: pickImageMaxHeight,
        imageQuality: pickImageImageQuality,
      );
      if (pickedFile != null && isCrop) {
        return cropImage(
            file: File(pickedFile.path),
            context: context.mounted ? context : context,
            uiSettings: uiSettings,
            cropImageMaxHeight: cropImageMaxHeight,
            cropImageMaxWidth: cropImageMaxWidth);
      }

      return pickedFile != null ? File(pickedFile.path) : null;
    } else {
      return null;
    }
  }

  Future<File?> getFromCameraWithPermissionCheck({
    required BuildContext context,
    required String permissionDescriptionText,
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,
    bool isCrop = false,
    List<PlatformUiSettings>? uiSettings,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    double? pickImageMaxWidth,
    double? pickImageMaxHeight,
    int? pickImageImageQuality,
    bool saveCameraImage = false,
    int? cropImageMaxWidth,
    int? cropImageMaxHeight,
  }) async {
    if (await PermissionHandler().getCameraPermission(
        context: context,
        deniedPermissionsSettingsDialogModel:
            deniedPermissionsSettingsDialogModel,
        permissionDescriptionText: permissionDescriptionText)) {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: pickImageMaxWidth,
        maxHeight: pickImageMaxHeight,
        imageQuality: pickImageImageQuality,
      );
      if (pickedFile != null && isCrop) {
        File? croppedImageFile = await cropImage(
            file: File(pickedFile.path),
            context: context.mounted ? context : context,
            uiSettings: uiSettings,
            cropImageMaxWidth: cropImageMaxWidth,
            cropImageMaxHeight: cropImageMaxHeight);
        if (croppedImageFile != null && saveCameraImage) {
          await Gal.putImage(croppedImageFile.path);
        }
        return croppedImageFile;
      }
      if (pickedFile != null && saveCameraImage) {
        await Gal.putImage(pickedFile.path);
      }
      return pickedFile != null ? File(pickedFile.path) : null;
    } else {
      return null;
    }
  }
}

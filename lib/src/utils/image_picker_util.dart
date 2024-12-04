import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  Future<void> showImagePickerBottomSheet({
    /// [context] as BuildContext
    context,

    /// [bottomSheetTitle] pass String value for ImagePicker bottomSheet's title
    String? bottomSheetTitle,

    /// [cameraTitle] pass String value for ImagePicker bottomSheet's camera option title
    String? cameraTitle,

    /// [galleryTitle] pass String value for ImagePicker bottomSheet's gallery option title
    String? galleryTitle,

    /// [cameraPermissionDescriptionText] pass String value for permanently denied camera permission dialog description
    String? cameraPermissionDescriptionText,

    /// [galleryPermissionDescriptionText] pass String value for permanently denied photo/storage permission dialog description to access images
    String? galleryPermissionDescriptionText,

    /// [isCropImage] pass bool value true for enable image cropping
    bool isCropImage = false,

    /// [bottomSheetTitleStyle] pass TextStyle for ImagePicker bottomSheet's title
    TextStyle? bottomSheetTitleStyle,

    /// [cameraTitleStyle] pass TextStyle for ImagePicker bottomSheet's camera title text
    TextStyle? cameraTitleStyle,

    /// [galleryTitleStyle] pass TextStyle for ImagePicker bottomSheet's gallery title text
    TextStyle? galleryTitleStyle,

    /// [bottomSheetInternalPadding] ImagePicker bottomSheet's internal padding
    EdgeInsetsGeometry? bottomSheetInternalPadding,

    /// [bottomSheetItemPadding] ImagePicker bottomSheet's item padding (camera,gallery)
    EdgeInsetsGeometry? bottomSheetItemPadding,

    /// [bottomSheetTitlePadding] ImagePicker bottomSheet's title padding
    EdgeInsetsGeometry? bottomSheetTitlePadding,

    /// [cropImagePlatformUiSettings] pass the List<PlatformUiSettings> if [isCropImage] is true
    List<PlatformUiSettings>? cropImagePlatformUiSettings,

    /// [cropImageAspectRatioPresets] pass the List<CropAspectRatioPreset> if [isCropImage] is true
    List<CropAspectRatioPreset>? cropImageAspectRatioPresets,

    /// [cropImageAspectRatioPresets] pass the int value if [isCropImage] is true
    int? cropImageMaxWidth,

    /// [cropImageMaxHeight] pass the int value if [isCropImage] is true
    int? cropImageMaxHeight,

    /// [pickImageImageQuality] pass the int value between 0 to 100 for image compression while picking image
    int? pickImageImageQuality,

    /// [bottomSheetShape] pass the ShapeBorder according to your requirement
    ShapeBorder? bottomSheetShape,

    /// [savePickedCameraImageToStorage] pass the bool value to true if you want to save the capture image from camera to gallery
    bool savePickedCameraImageToStorage = false,

    /// Return the selected file from the image picker
    required Function(File? file) onImageSelection,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
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
    ///  pass file object
    required File file,

    /// pass the BuildContext
    required BuildContext context,

    /// [uiSettings] controls UI customization on specific platform (android, ios, web,...)
    /// See:
    ///  * [AndroidUiSettings] controls UI customization for Android
    ///  * [IOSUiSettings] controls UI customization for iOS    List<PlatformUiSettings>? uiSettings,
    List<PlatformUiSettings>? uiSettings,

    ///  [aspectRatioPresets] controls the list of aspect ratios in the crop menu view.
    List<CropAspectRatioPreset>? aspectRatioPresets,

    /// [cropImageMaxWidth] pass int value for max width of cropImage
    int? cropImageMaxWidth,

    /// [cropImageMaxHeight] pass int value for max height of cropImage
    int? cropImageMaxHeight,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      maxHeight: cropImageMaxHeight,
      maxWidth: cropImageMaxWidth,
      sourcePath: file.path,
      uiSettings: uiSettings ??
          [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).appBarTheme.backgroundColor,
              toolbarWidgetColor: Theme.of(context).iconTheme.color,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: aspectRatioPresets ??
                  [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
            ),
            IOSUiSettings(
              title: 'Cropper',
              aspectRatioPresets: aspectRatioPresets ??
                  [
                    CropAspectRatioPreset.square,
                    CropAspectRatioPreset.ratio3x2,
                    CropAspectRatioPreset.original,
                    CropAspectRatioPreset.ratio4x3,
                    CropAspectRatioPreset.ratio16x9
                  ],
            ),
          ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  /// below method is for pick image from gallery

  Future<File?> getFromGalleryWithPermissionCheck({
    /// pass the BuildContext
    required BuildContext context,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,

    /// [permissionDescriptionText] pass String value for permanently denied photo/storage permission dialog description to access images
    required String permissionDescriptionText,

    /// [uiSettings] controls UI customization on specific platform (android, ios, web,...)
    /// See:
    ///  * [AndroidUiSettings] controls UI customization for Android
    ///  * [IOSUiSettings] controls UI customization for iOS    List<PlatformUiSettings>? uiSettings,
    List<PlatformUiSettings>? uiSettings,

    ///  [aspectRatioPresets] controls the list of aspect ratios in the crop menu view.
    List<CropAspectRatioPreset>? aspectRatioPresets,

    /// [pickImageMaxWidth] pass double value for max width of picking Image
    double? pickImageMaxWidth,

    /// [pickImageMaxHeight] pass double value for max height of picking Image
    double? pickImageMaxHeight,

    /// [pickImageImageQuality] pass the int value between 0 to 100 for image compression while picking image
    int? pickImageImageQuality,

    /// [isCrop] pass bool value true for enable image cropping
    bool isCrop = false,

    /// [cropImageMaxWidth] pass int value for max width of cropImage
    int? cropImageMaxWidth,

    /// [cropImageMaxHeight] pass int value for max height of cropImage
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

  /// below method is for pick image from camera

  Future<File?> getFromCameraWithPermissionCheck({
    /// pass the BuildContext
    required BuildContext context,

    /// [deniedPermissionsSettingsDialogModel] pass the object to customize denied permission dialog
    DeniedPermissionsSettingsDialogModel? deniedPermissionsSettingsDialogModel,

    /// [permissionDescriptionText] pass String value for permanently denied camera permission dialog description to access camera
    required String permissionDescriptionText,

    /// [uiSettings] controls UI customization on specific platform (android, ios, web,...)
    /// See:
    ///  * [AndroidUiSettings] controls UI customization for Android
    ///  * [IOSUiSettings] controls UI customization for iOS    List<PlatformUiSettings>? uiSettings,
    List<PlatformUiSettings>? uiSettings,

    ///  [aspectRatioPresets] controls the list of aspect ratios in the crop menu view.
    List<CropAspectRatioPreset>? aspectRatioPresets,

    /// [pickImageMaxWidth] pass double value for max width of picking Image
    double? pickImageMaxWidth,

    /// [pickImageMaxHeight] pass double value for max height of picking Image
    double? pickImageMaxHeight,

    /// [pickImageImageQuality] pass the int value between 0 to 100 for image compression while picking image
    int? pickImageImageQuality,

    /// [isCrop] pass bool value true for enable image cropping
    bool isCrop = false,

    /// [cropImageMaxWidth] pass int value for max width of cropImage
    int? cropImageMaxWidth,

    /// [cropImageMaxHeight] pass int value for max height of cropImage
    int? cropImageMaxHeight,

    /// [saveCameraImage] pass the bool value to true if you want to save the capture image from camera to gallery
    bool saveCameraImage = false,
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

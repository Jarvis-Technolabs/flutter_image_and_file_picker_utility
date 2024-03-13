# **Introduction**

This Flutter package simplifies the process of picking images from both the camera and gallery, with
built-in permission handling, image cropping, saving picked camera images, image compression, and
file picking functionality. It aims to provide an easy-to-use solution for handling images and files
in your Flutter applications.

## **Features**

* Pick images from camera and gallery with permission handling
* Permission handling for camera and storage
* Image cropping functionality
* Save picked camera images to the device
* Image compression for optimized storage usage
* File picking with permission handling

## **Getting Started**

To integrate the package into your Flutter project, follow these steps:

### **Step 1: Add Dependency**

Add the following dependency to your pubspec.yaml file:

```
dependencies:
image_and_file_picker_utility: ^0.0.1

```

Then run:

```
flutter pub get

```

### **Step 2: Android Setup**

Add Permissions to AndroidManifest.xml:

```
<uses-permission android:name="android.hardware.camera" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

```

Add activity to the application tag for crop image:

```
<application>
<activity
android:name="com.yalantis.ucrop.UCropActivity"
android:exported="true"
android:screenOrientation="portrait"
android:theme="@style/Theme.AppCompat.Light.NoActionBar" />
</application>

```

### **Step 3: IOS Setup**

Add permission to the Podfile like below:

```
post_install do |installer|
installer.pods_project.targets.each do |target|
flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
      ]
    end

end
end

```

Add permission usage to the info.plist file:

```
<key>NSPhotoLibraryUsageDescription</key>
<string>Our application needs permission to access photos</string>
<key>NSCameraUsageDescription</key>
<string>Our application needs permission to capture photo</string>

```

## **Usage**

#### Image:

Image picking with bottom sheet:

```
await ImagePickerUtil().showImagePickerBottomSheet(
context: context,
isCropImage: true,
savePickedCameraImageToStorage: true,
pickImageImageQuality: 100,
onImageSelection: (File? pickedImage) {}
);

```

Image picking from camera:

```
File? file = await getFromCameraWithPermissionCheck(
context: context,
permissionDescriptionText:
"Permission required to access camera",
isCrop: true,
saveCameraImage:
true,);

```

Image picking from gallery:

```
File? file = await getFromGalleryWithPermissionCheck(
context: context,
permissionDescriptionText:
'Permission required to access gallery',
isCrop: true,);

```

Image cropping

```
File? file = await cropImage(
file: File("path"),
context: context,
);

```

#### File:

```
import 'package:file_picker/file_picker.dart';
```
```
final List<File>? pickedFileList =
await FilePickerUtil().getFilePicker(
allowMultiple: true,
allowCompression: true,
fileType: FileType.any,
context: context,
/// When you want to pick specific extensions files then choose type as FileType.custom and pass the extensions using allowedExtensions parameter
// type:FileType.custom,
// allowedExtensions: ['jpg', 'pdf', 'doc'],
);

```

#### Permission Handling:

Storage permission:

```
bool isPermissionGranted = await PermissionHandler().getStoragePermission(
context: context,
permissionDescriptionText:"Permission is required to access files",
)

```

Camera permission:

```
bool isPermissionGranted = await PermissionHandler().getCameraPermission(
context: context,
permissionDescriptionText: "Permission required to access camera")

```

Photos permission (For IOS only):

```
bool isPermissionGranted = await PermissionHandler().getPhotosPermission(
context: context,
permissionDescriptionText: "Permission required to access photos")

```

Open settings for denied permission:

```
await PermissionHandler().openSettings();

```

## **ScreenShots**

<a href="https://drive.google.com/file/d/1cJoT9aE33n7zhihpOi4aNVidicVwwlhl/view?usp=sharing"><img src="https://drive.google.com/file/d/1cJoT9aE33n7zhihpOi4aNVidicVwwlhl/view?usp=sharing" style="width: 350px; max-width: 100%; height: auto" title=" ScreenShot 1" />

<a href="https://drive.google.com/file/d/1-tC0LZAMC81L8sZDOFF2K9_5Sc7GfoPc/view?usp=sharing"><img src="https://drive.google.com/file/d/1-tC0LZAMC81L8sZDOFF2K9_5Sc7GfoPc/view?usp=sharing" style="width: 350px; max-width: 100%; height: auto" title=" ScreenShot 2" />

<a href="https://drive.google.com/file/d/1tLEVsagiiMYYz1W9wz8xWf6-HeTxpqaq/view?usp=sharing"><img src="https://drive.google.com/file/d/1tLEVsagiiMYYz1W9wz8xWf6-HeTxpqaq/view?usp=sharing" style="width: 350px; max-width: 100%; height: auto" title=" ScreenShot 3" />

<a href="https://drive.google.com/file/d/1EYTmqTqwoApACPTyKiLS2oGCH5BnmPPj/view?usp=sharing"><img src="https://drive.google.com/file/d/1EYTmqTqwoApACPTyKiLS2oGCH5BnmPPj/view?usp=sharing" style="width: 350px; max-width: 100%; height: auto" title=" ScreenShot 4" />

<a href="https://drive.google.com/file/d/1e_0DjDVbRY_pWR4LDxXNyYmKnQgsEmqI/view?usp=sharing"><img src="https://drive.google.com/file/d/1e_0DjDVbRY_pWR4LDxXNyYmKnQgsEmqI/view?usp=sharing" style="width: 350px; max-width: 100%; height: auto" title=" ScreenShot 5" />
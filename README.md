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
      onImageSelection: (File? pickedImage) {},
    );

```

Image picking from camera:

```
    File? file = await getFromCameraWithPermissionCheck(
      context: context,
      permissionDescriptionText: "Permission required to access camera",
      isCrop: true,
      saveCameraImage: true,
    );

```

Image picking from gallery:

```
    File? file = await getFromGalleryWithPermissionCheck(
      context: context,
      permissionDescriptionText: 'Permission required to access gallery',
      isCrop: true,
    );

```

Image cropping

```
    import 'package:image_cropper/image_cropper.dart';
```

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
    final List<File>? pickedFileList = await FilePickerUtil().getFilePicker(
      allowMultiple: true,
      allowCompression: true,
      fileType: FileType.any,
      context: context,
      /// When you want to pick specific extensions files then choose type as FileType.custom and pass the extensions using allowedExtensions parameter
      // fileType:FileType.custom,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

```

#### Permission Handling:

Storage permission:

```
    bool isPermissionGranted = await PermissionHandler().getStoragePermission(
      context: context,
      permissionDescriptionText: "Permission is required to access files",
    );

```

Camera permission:

```
    bool isPermissionGranted = await PermissionHandler().getCameraPermission(
      context: context,
      permissionDescriptionText: "Permission required to access camera",
    );

```

Photos permission (For IOS only):

```
    bool isPermissionGranted = await PermissionHandler().getPhotosPermission(
      context: context,
      permissionDescriptionText: "Permission required to access photos",
    );

```

Open settings for denied permission:

```
    await PermissionHandler().openSettings();
```

## **ScreenShots**

<img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYwMzElrDi1Vk7X_zRiB-1q_Z_3uOhq9c3_283OG-rJ5kE9YFC0pfHudtvrOhL5yD1Xk18VRzJgyGmUaphWJZvEG6qkMQ=s1600" alt=" ScreenShot 1" height="310">

<img src="https://lh3.googleusercontent.com/drive-viewer/AKGpiha1U4CsZ7UCPGFfrU8OwXorMNE83TDG_wUG8SBMOar9rDz4G5OC8q1vT5h8SwBk0vrZOEo_waTnPvGo74M2wcAW9gkiRQ=s1600" alt=" ScreenShot 2" height="310">

<img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYqO70FllWJXya713EctnK-F1IXnthdnibCEzcaasJ-PaYUukNoz-Y7LcVYs0dnrPw6vyf7FuHkJrnx0oqwI43ejyhwjQ=s1600" alt=" ScreenShot 3" height="310">

<img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihbTnLIfdzajP1E2gDn9Lf6cYeVfw6drr9XslZn1QVQvt_Ppx5THn-MCa0h5AQzTZj4Ppq0qegF2XfnI6VV-vHeoxUL4QQ=s1600" alt=" ScreenShot 4" height="310">

<img src="https://lh3.googleusercontent.com/drive-viewer/AKGpihYAOolKvsxtTU2e76vvkiQCUrObmss8FKUYre7vZWztx1m-4A4X_hQ42-CWR5eYn0WDMUEXvBvGzmL7Qvr4B2keX7w9Dw=s1600" alt=" ScreenShot 5" height="310">


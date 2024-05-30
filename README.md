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

## **Flutter Compatibility**

| **Package version** | **Flutter version** |
|:-------------------:|:-------------------:|
|    0.0.1 - 0.0.8    |      >=1.17.0       |

## **Getting Started**

To integrate the package into your Flutter project, follow these steps:

### **Step 1: Add Dependency**

Add the following dependency to your pubspec.yaml file:

``` dart
    dependencies:
      image_and_file_picker_utility: ^0.0.7

```

Then run:

``` dart
    flutter pub get

```

### **Step 2: Android Setup**

Add Permissions to AndroidManifest.xml:

``` xml
    <uses-permission android:name="android.hardware.camera" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

```

Add activity to the application tag for crop image:

``` xml
    <application>
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:exported="true"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar" 
        </activity>
    </application>

```

### **Step 3: IOS Setup**

Add permission to the Podfile like below:

``` ruby
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

``` xml
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Our application needs permission to access photos</string>
    <key>NSCameraUsageDescription</key>
    <string>Our application needs permission to capture photo</string>
```

## **Usage**

#### Image:

Image picking with bottom sheet:

``` dart
    await ImagePickerUtil().showImagePickerBottomSheet(
      context: context,
      isCropImage: true,
      savePickedCameraImageToStorage: true,
      pickImageImageQuality: 100,
      onImageSelection: (File? pickedImage) {},
    );

```

Image picking from camera:

``` dart
    File? file = await getFromCameraWithPermissionCheck(
      context: context,
      permissionDescriptionText: "Permission required to access camera",
      isCrop: true,
      saveCameraImage: true,
    );

```

Image picking from gallery:

``` dart
    File? file = await getFromGalleryWithPermissionCheck(
      context: context,
      permissionDescriptionText: 'Permission required to access gallery',
      isCrop: true,
    );

```

Image cropping

``` dart
    import 'package:image_cropper/image_cropper.dart';
```

``` dart
    File? file = await cropImage(
      file: File("path"),
      context: context,
    );

```

#### File:

``` dart
    import 'package:file_picker/file_picker.dart';
```

``` dart
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

``` dart
    bool isPermissionGranted = await PermissionHandler().getStoragePermission(
      context: context,
      permissionDescriptionText: "Permission is required to access files",
    );

```

Camera permission:

``` dart
    bool isPermissionGranted = await PermissionHandler().getCameraPermission(
      context: context,
      permissionDescriptionText: "Permission required to access camera",
    );

```

Photos permission (For IOS only):

``` dart
    bool isPermissionGranted = await PermissionHandler().getPhotosPermission(
      context: context,
      permissionDescriptionText: "Permission required to access photos",
    );

```

Open settings for denied permission:

``` dart
    await PermissionHandler().openSettings();
```

## **ScreenShots**

<a href="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/1.png"><img src="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/1.png" alt=" ScreenShot 1" height="310"/>
<a href="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/2.png"><img src="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/2.png" alt=" ScreenShot 2" height="310"/>
<a href="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/3.png"><img src="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/3.png" alt=" ScreenShot 3" height="310"/>
<a href="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/4.png"><img src="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/4.png" alt=" ScreenShot 4" height="310"/>
<a href="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/5.png"><img src="https://raw.githubusercontent.com/Jarvis-Technolabs/image_and_file_picker_utility/assets/5.png" alt=" ScreenShot 5" height="310"/>


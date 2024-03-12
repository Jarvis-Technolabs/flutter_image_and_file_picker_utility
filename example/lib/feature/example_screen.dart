import 'dart:io';
import 'package:example/feature/widget/custom_button.dart';
import 'package:example/feature/widget/file_list_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/image_and_file_picker_utility.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  List<File> files = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Files',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: files.length + 1,
                  itemBuilder: (context, index) {
                    if (index == files.length) {
                      return SizedBox.shrink();
                    }
                    return FileListItem(
                      file: files[index],
                      onPressed: () {},
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Pick Image',
                    onPressed: () async {
                      await ImagePickerUtil().showImagePickerBottomSheet(
                          context: context,
                          isCropImage: true,
                          savePickedCameraImageToStorage: true,
                          pickImageImageQuality: 100,
                          onImageSelection: (File? pickedImage) {
                            if (pickedImage != null) {
                              setState(() {
                                files.add(pickedImage);
                              });
                            }
                          });
                    },
                  ),
                  CustomButton(
                    text: 'Pick File',
                    onPressed: () async {
                      final List<File>? pickedFileList =
                          await FilePickerUtil().getFilePicker(
                        allowMultiple: true,
                        allowCompression: true,
                        fileType: FileType.any,

                        /// When you want to pick specific extensions files then choose type as FileType.custom and pass the extensions using allowedExtensions parameter
                        // type:FileType.custom,
                        // allowedExtensions: ['jpg', 'pdf', 'doc'],
                        context: context,
                      );
                      if (pickedFileList != null && pickedFileList.isNotEmpty) {
                        for (var file in pickedFileList) {
                          setState(() {
                            files.add(file);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

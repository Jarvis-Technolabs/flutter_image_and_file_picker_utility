import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_and_file_picker_utility/utils/file_picker_util.dart';
import 'package:image_and_file_picker_utility/utils/image_picker_util.dart';
import 'package:file_picker/file_picker.dart';


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
                    return FileButton(
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
                          savePickedCameraImageToStorage:true,
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

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      ),
      child: Text(text),
    );
  }
}

class FileButton extends StatelessWidget {
  final File file;
  final VoidCallback onPressed;

  const FileButton({
    required this.file,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            file.path.split('/').last,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

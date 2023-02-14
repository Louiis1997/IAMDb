import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class ProfileImagePicker extends StatelessWidget {
  final Future Function(ImageSource source) pickImage;
  final File? imageFile;

  const ProfileImagePicker({
    Key? key,
    required this.pickImage,
    this.imageFile,
  }) : super(key: key);

  static Image img = Image.network(
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWdArwtZM3Gky98tefwUkAmTxS6KLSqI5NFg&usqp=CAU");

      @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage:
              imageFile == null ? img.image : FileImage(File(imageFile!.path)),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            child: const Icon(
              Icons.camera_alt,
              color: Color.fromRGBO(244, 197, 24, 1),
              size: 28,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      "Choose Profile Photo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          GestureDetector(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Color.fromRGBO(244, 197, 24, 1),
                                  ),
                                ),
                                Text(
                                  "Camera",
                                ),
                              ],
                            ),
                            onTap: () {
                              pickImage(ImageSource.camera);
                            },
                          ),
                          GestureDetector(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.image,
                                    color: Color.fromRGBO(244, 197, 24, 1),
                                  ),
                                ),
                                Text(
                                  "Gallery",
                                ),
                              ],
                            ),
                            onTap: () {
                              pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

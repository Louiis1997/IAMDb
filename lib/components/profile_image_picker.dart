import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart';

class ProfileImagePicker extends StatelessWidget {
  final Future Function(ImageSource source) pickImage;
  final File? imageFile;
  const ProfileImagePicker({Key? key, required this.pickImage, this.imageFile,}) : super(key: key);

  static Image img = Image.memory(base64Decode(
      "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"));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: imageFile == null
              ? img.image
              : FileImage(File(imageFile!.path)),
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

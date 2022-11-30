import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() => runApp(ImagePickerApp());

class ImagePickerApp extends StatefulWidget {
  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;
  File? _video;

  Future getVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) {
        return;
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getExternalStorageDirectory();
    // var x = await getExternalStorageDirectory();
    // print(x)
    String? dirDir = directory?.path;
    print(dirDir);

    final name = basename(imagePath);
    final image = File('${directory?.path}/$name');

    print(image);

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pick Image'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              _image != null
                  ? Image.file(
                      _image!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "https://www.incimages.com/uploaded_files/image/1920x1080/getty_900243400_200013332000928019_376415.jpg"),
              const SizedBox(
                height: 50,
              ),
              CustomButton(
                title: 'Pick from Gallery',
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery),
              ),
              CustomButton(
                title: 'Pick from video',
                icon: Icons.video_call,
                onClick: () => getVideo(ImageSource.camera),
              ),
              CustomButton(
                title: 'Pick from camera',
                icon: Icons.camera_alt,
                onClick: () => getImage(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 50,
          ),
          Text(title)
        ],
      ),
    ),
  );
}

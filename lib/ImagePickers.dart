import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';


void main() => runApp(ImagePickerApp());

class ImagePickerApp extends StatefulWidget {
  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;
  File? _video;

  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        'https://youtu.be/tkIASyEV3jQ');
    _videoPlayerController.initialize().then((_) {
      setState() {}
    });
  }

  Future getVideo(ImageSource source) async{
    try{
      final video = await ImagePicker().pickVideo(source: source);
      if( video == null ){
        return;
      }

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(video.path);

      setState(() {
        this._video = imagePermanent;
      });
    }
    catch (e){
      print('Failed to pick image: $e');
    }
  }

  Future getImage(ImageSource source) async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if( image == null ){
        return;
      }

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    }
    catch (e){
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async{
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
      home:Scaffold(
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
                  : Image.network("https://www.incimages.com/uploaded_files/image/1920x1080/getty_900243400_200013332000928019_376415.jpg"),
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
  Widget build(BuildContext context) {
    return Scaffold(
        body: AspectRatio(
            aspectRatio: 1280 / 720,
            child: Stack(
              children: <Widget>[
                VideoPlayer(_videoPlayerController),
                Positioned(
                  bottom: 0,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.play_arrow,
                            size: 20.0, color: Colors.white),
                        onTap: () {
                          setState(() {
                            _videoPlayerController.play();
                          });
                        },
                      ),
                      GestureDetector(
                        child: Icon(Icons.pause,
                            size: 20.0, color: Colors.white),
                        onTap: () {
                          setState(() {
                            _videoPlayerController.pause();
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            )));
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











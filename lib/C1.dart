import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';

List<CameraDescription>? cameras;//有前置、後置等等的鏡頭
CameraController? controller;//設定CameraController

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  @override
  void initState() {
    controller = CameraController(cameras![0], ResolutionPreset.medium);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller!.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CameraPreview(controller!),
      ),
    );
  }
}

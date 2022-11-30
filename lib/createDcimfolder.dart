import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:external_path/external_path.dart';


void main() => runApp(create());

class create extends StatefulWidget {
  const create({Key? key}) : super(key: key);

  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  String? _directoryPath;
  String? _dcim_path;
  FilePickerResult? result;
  String? _fileName;
  String? pickfile;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text(
                "create folder",
              ),
              onPressed: () {
                createNewDir();
              },
            ),
            ElevatedButton(
              child: Text(
                "find folder",
              ),
              onPressed: () {
                _setFolder();
              },
            ),
            ElevatedButton(
              child: Text(
                "pick file",
              ),
              onPressed: () {
                _selectFile();
              },
            ),
          ],
        ),
      ),
    );
  }


  _selectFile() async {
    print(_dcim_path);
    requestPermission();
    try{
      result = await FilePicker.platform.pickFiles
        (
          type: FileType.any,
          initialDirectory: _directoryPath,
      );
      if(result!=null){
        _fileName = result!.files.first.name;
      }else{
        return false;
      }
      print(_fileName);
    }catch(e){
      print(e);
    }



}
  Future<void> _setFolder() async {
    requestPermission();
    try{
      var path = await FilePicker.platform.getDirectoryPath(initialDirectory: _dcim_path);
      setState(() {
        _directoryPath = path;
      });
      print(_directoryPath);
    }catch (e){
      print(e);
    }
  }


  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _directoryPath = null;
    });
  }



  Future createNewDir() async {
    requestPermission();
    final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DCIM);
    print(dir);

    setState(() {
      _dcim_path = ("$dir/app");
    });

    var file = Directory("$dir/app");

    print(file);
    try {
      bool exists = await file.exists();
      if (!exists) {
        await file.create();
        print("創建成功");
      } else {
        print("存在");
      }
    } catch (e) {
      print(e);
    }
    print(file.path);
  }

  Future requestPermission() async {
    if (await Permission.contacts.request().isGranted) {
// Either the permission was already granted before or the user just granted it.
    }
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    print(statuses[Permission.storage]);
  }
}














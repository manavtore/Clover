import 'package:blackoffer/Models/LocationModel.dart';
import 'package:blackoffer/Models/UserModel.dart';
import 'package:blackoffer/Models/VideoModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

String? URL;
XFile? RealVideoFile;
recordvideo() async {
  final Picker = ImagePicker();
  XFile? videoFile;
  try {
    videoFile = await Picker.pickVideo(source: ImageSource.camera);
    RealVideoFile = videoFile!.path as XFile?;
    return videoFile.path;
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

TextEditingController TitleController = TextEditingController();
TextEditingController DescriptionController = TextEditingController();

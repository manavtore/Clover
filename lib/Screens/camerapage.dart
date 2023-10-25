import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blackoffer/Screens/videoeditingscreen.dart';
import 'package:blackoffer/Services/Flutter_Camera.dart';

class CameraPage extends StatefulWidget {
  final Position location;

  const CameraPage({Key? key, required this.location}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterCamera(
      color: Colors.amber,
      onVideoRecorded: (value) {
        final path = value.path;
        final file = File(path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoEditingScreen(
                videoURL: file.path, location: widget.location),
          ),
        );
      },
    );
  }
}

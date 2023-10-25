import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';

import 'package:blackoffer/Screens/videoeditingscreen.dart';
import 'package:blackoffer/Utils/AppBar.dart';
import 'package:blackoffer/Screens/GPS_permission.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late CameraController _cameraController;
  bool _isLoading = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(
      front,
      ResolutionPreset.max,
    );
    await _cameraController.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  _startRecording() async {
    if (_cameraController.value.isInitialized) {
      final file = await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  _stopRecording() async {
    if (_cameraController.value.isRecordingVideo) {
      final file = await _cameraController.stopVideoRecording();
      if (file?.path != null) {
        setState(() => _isRecording = false);
        final position = await determinePosition();
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) =>
              VideoEditingScreen(videoURL: file.path, location: position),
        );
        Navigator.push(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstant.mainAppBar,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(_cameraController),
                GestureDetector(
                  onTapDown: (_) => _startRecording(),
                  onTapUp: (_) => _stopRecording(),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Explore"),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GPS_Permission(),
                  ),
                ),
                icon: const Icon(Icons.add),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Library"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

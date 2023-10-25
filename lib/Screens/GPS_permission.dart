import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blackoffer/Screens/camerapage.dart';

class GPS_Permission extends StatefulWidget {
  const GPS_Permission({Key? key}) : super(key: key);

  @override
  State<GPS_Permission> createState() => _GPS_PermissionState();
}

class _GPS_PermissionState extends State<GPS_Permission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final position = await determinePosition();
            print(position);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CameraPage(location: position),
              ),
            );
          },
          child: const Text('GPS Permission'),
        ),
      ),
    );
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
}

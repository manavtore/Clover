import 'dart:io';
import 'package:blackoffer/Models/VideoModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackoffer/Models/LocationModel.dart' as app;
import 'package:geocoding/geocoding.dart' as geo;

class VideoEditingScreen extends StatefulWidget {
  final String videoURL;
  final Position location;

  const VideoEditingScreen(
      {Key? key, required this.videoURL, required this.location})
      : super(key: key);

  @override
  State<VideoEditingScreen> createState() => _VideoEditingScreenState();
}

class _VideoEditingScreenState extends State<VideoEditingScreen> {
  late VideoPlayerController _controller;
  VideoCategory _selectedCategory = VideoCategory.music;

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descr = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoURL))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Editing Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_controller.value.isInitialized)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 800,
                    child: AspectRatio(
                      aspectRatio: 9.0 / 20.0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.replay,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _controller.seekTo(const Duration(seconds: 0));
                      _controller.play();
                    },
                  ),
                ],
              )
            else
              const CircularProgressIndicator(),
            if (_controller.value.isInitialized)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                    ),
                    TextField(
                      controller: _descr,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedCategory.toString().split('.').last,
                      items: VideoCategory.values
                          .map((category) => DropdownMenuItem(
                                value: category.toString().split('.').last,
                                child:
                                    Text(category.toString().split('.').last),
                              ))
                          .toList(),
                      onChanged: (category) {
                        setState(() {
                          _selectedCategory = VideoCategory.values.firstWhere(
                              (e) => e.toString().split('.').last == category!);
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () => postVideo(),
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> postVideo() async {
    final storage = FirebaseStorage.instance;
    final firestore = FirebaseFirestore.instance;

    final storageRef = storage
        .ref()
        .child('videos/${DateTime.now().millisecondsSinceEpoch}.mp4');

    final uploadTask = await storageRef.putFile(File(widget.videoURL));

    final videoURL = await uploadTask.ref.getDownloadURL();

    final placemarks = await geo.placemarkFromCoordinates(
        widget.location.latitude, widget.location.longitude);

    final locationName =
        placemarks.isNotEmpty ? placemarks[0].name : "Unknown Location";

    app.Location location = app.Location(
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
      address: locationName,
    );

    Video post = Video(
      title: _titleController.text,
      description: _descr.text,
      category: _selectedCategory.toString().split('.').last,
      location: location, // Assign the Location object directly
      videoUrl: videoURL,
      uploadTime: DateTime.now(),
      user: " ",
    );

    // Store the video details in Firebase.
    await firestore.collection('videos').add(post.toMap());
  }
}

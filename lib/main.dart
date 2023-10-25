import 'dart:io';
import 'package:blackoffer/Screens/homepage.dart';
import 'package:blackoffer/Theme/apptheme.dart';
import 'package:blackoffer/auth/AuthView.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        hintColor: Colors.green,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
        ),
        hintColor: Colors.green,
      ),
      themeMode: ThemeMode.system,
      home: const Homepage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  late CameraController _cameraController;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  bool _isRecording = false;

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          var tweets = snapshot.data!.docs;
          return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                var tweet = tweets[index].data();

                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                      leading: const SizedBox(
                        width: 45,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/flutterfeed-5cd86.appspot.com/o/Profilepic%2Fdilvich.jpeg?alt=media&token=1b4d39f5-d56f-4758-b9d0-04f91912a121&_gl=1*1igpife*_ga*MTQ3NDc1NTA0NS4xNjkzOTc4MDU3*_ga_CW55HF8NVT*MTY5NzYzNDE0MC40Ny4xLjE2OTc2MzY5NTguNTQuMC4w'),
                        ),
                      ),
                      title: Text(
                        tweet['name'] ?? 'Username',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tweet['text']),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 250,
                              child: Image.network(
                                tweet['imageUrl']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.comment),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.repeat),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.favorite),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              });
        },
      );
    }
  }
}

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              print('do something with the file');
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}

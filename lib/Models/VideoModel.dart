import 'package:blackoffer/Models/LocationModel.dart';

enum VideoCategory {
  music,
  sports,
  travel,
}

class Video {
  final String title;
  final String description;
  final String category;
  final Location location;
  final String videoUrl;
  final DateTime uploadTime;
  final String user;

  Video({
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.videoUrl,
    required this.uploadTime,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'location': location.toMap(),
      'videoUrl': videoUrl,
      'uploadTime': uploadTime.toIso8601String(),
      'user': user,
    };
  }
}

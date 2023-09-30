import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SingleVideoScreen extends StatefulWidget {
  final Map<String, dynamic> videoData;

  const SingleVideoScreen({Key? key, required this.videoData}) : super(key: key);

  @override
  _SingleVideoScreenState createState() => _SingleVideoScreenState();
}

class _SingleVideoScreenState extends State<SingleVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoData['videoUrl']);
    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.videoData['title'] ?? '';
    final String description = widget.videoData['description'] ?? '';
    final String category = widget.videoData['category'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView( // Wrap the Column with a ListView
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          ListTile(
            leading: Icon(Icons.title),
            title: Text('Title: $title'),
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Description: $description'),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Category: $category'),
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

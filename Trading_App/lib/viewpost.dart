import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: AllPostsPage(),
  ));
}

class AllPostsPage extends StatefulWidget {
  @override
  _AllPostsPageState createState() => _AllPostsPageState();
}

class _AllPostsPageState extends State<AllPostsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      DatabaseEvent event = await _database.child('posts').once();
      List<Post> posts = [];

      Map<dynamic, dynamic>? values = event.snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        values.forEach((key, value) {
          Post post = Post.fromMap(value);
          posts.add(post);
        });
      }

      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Error loading posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Posts'),
      ),
      body: _posts == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(_posts[index]);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    String formattedTimestamp = _formatTimestamp(post.timestamp);

    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posted $formattedTimestamp'),
            Text('Title: ${post.title}'),
            Text('Body: ${post.body}'),

            if (post.images.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Images:'),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (File image in post.images)
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],

            if (post.videos.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('Videos:'),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int index = 0; index < post.videos.length; index++)
                        Container(
                          width: 300,
                          height: 200,
                          margin: EdgeInsets.only(right: 10),
                          child: Chewie(
                            controller: ChewieController(
                              videoPlayerController:
                              VideoPlayerController.file(post.videos[index]),
                              autoPlay: false,
                              looping: false,
                              aspectRatio: 16 / 9,
                              autoInitialize: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],

            if (post.urls.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('URLs:'),
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (String? url in post.urls)
                        FutureBuilder(
                          future: _fetchUrlContent(url!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error fetching content from URL');
                            } else if (snapshot.hasData) {
                              String content = snapshot.data.toString();
                              if (url.endsWith('.mp4')) {
                                return Container(
                                  width: 300,
                                  height: 200,
                                  margin: EdgeInsets.only(right: 10),
                                  child: Chewie(
                                    controller: ChewieController(
                                      videoPlayerController:
                                      VideoPlayerController.network(url),
                                      autoPlay: false,
                                      looping: false,
                                      aspectRatio: 16 / 9,
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 300,
                                  height: 200,
                                  margin: EdgeInsets.only(right: 10),
                                  child: WebView(
                                    initialUrl: url,
                                    javascriptMode: JavascriptMode.unrestricted,
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(postTime);
    }
  }

  Future<String?> _fetchUrlContent(String url) async {
    return "URL Content for $url";
  }
}

class Post {
  String title;
  String body;
  List<File> images;
  List<String?> urls;
  List<File> videos;
  int timestamp;

  Post({
    required this.title,
    required this.body,
    required this.images,
    required this.urls,
    required this.videos,
    required this.timestamp,
  });
  factory Post.fromMap(Map<dynamic, dynamic> map) {
    List<File> images = (map['images'] as List?)
        ?.map((imagePath) => File(imagePath as String))
        .toList() ?? [];

    List<File> videos = (map['videos'] as List?)
        ?.map((videoPath) => File(videoPath as String))
        .toList() ?? [];

    List<String?> urls = (map['urls'] as List?)
        ?.map((url) => url as String?)
        .toList() ?? [];

    int timestamp = int.tryParse(map['timestamp'] ?? '') ?? 0;

    return Post(
      title: map['title'] as String,
      body: map['body'] as String,
      images: images,
      urls: urls,
      videos: videos,
      timestamp: timestamp,
    );
  }

}

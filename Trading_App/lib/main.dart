import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trading_app/splash_screen.dart';
import 'package:trading_app/viewpost.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  Future<void> submitPost(Post post) async {
    try {
      DatabaseReference newPostRef = _database.child('posts').push();

      String formattedTimestamp = DateFormat('HH:mm:ss').format(DateTime.now());

      await newPostRef.set({
        'title': post.title,
        'body': post.body,
        'topics': post.topics,
        'isPublic': post.isPublic,
        'timestamp': formattedTimestamp,
      });


      List<String> imageUrls = post.images.map((image) => image.path).toList();
      await newPostRef.child('images').set(imageUrls);


      List<String> videoUrls = post.videos.map((video) => video.path).toList();
      await newPostRef.child('videos').set(videoUrls);

      await newPostRef.child('urls').set(post.urls);

    } catch (e) {
      print('Error submitting post: $e');
    }
  }
}
class Post {
  String title;
  String body;
  List<String> topics;
  List<File> images;
  bool isPublic;
  List<String?> urls;
  List<File> videos;

  Post({
    required this.title,
    required this.body,
    required this.topics,
    required this.images,
    required this.isPublic,
    required this.urls,
    required this.videos,
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDa_mzaO0Du8zEZL_EBKRbqNBMk7ZZc92k",
        appId: "1:635722570599:android:b5a4d1514a08dbf983edc2",
        messagingSenderId: "635722570599",
        projectId: "trading-app-3a52f"
    ),
  )
      : await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  List<String> _selectedTopics = [];
  List<File> _selectedImages = [];
  List<File> _selectedVideos = [];
  bool _isPublic = true;
  List<String?> _enteredUrls = [];

  Future<void> _pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedVideos.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _pickUrl() async {
    String? url = await _showDialog('Enter URL');
    if (url != null && url.isNotEmpty) {
      setState(() {
        _enteredUrls.add(url);
      });
    }
  }

  Future<String?> _fetchUrlContent(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Create a Post', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Enter title...',
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _bodyController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'What do you want to share?',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(20.0),
                ),
              ),
              const SizedBox(height: 25),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: const Text('Add Image', style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _pickUrl,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: const Text('Add URL', style: TextStyle(color: Colors.white),),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      child: const Text('Add Video', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Public Post'),
                value: _isPublic,
                onChanged: (bool? value) {
                  setState(() {
                    _isPublic = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Post post = Post(
                    title: _titleController.text,
                    body: _bodyController.text,
                    topics: _selectedTopics,
                    images: _selectedImages,
                    isPublic: _isPublic,
                    urls: _enteredUrls,
                    videos: _selectedVideos,
                  );
                  _showPostPreview(post);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                ),
                child: const Text('Preview Post', style: TextStyle(color: Colors.white), ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostPreview(Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Post Preview' ,style: TextStyle(color: Colors.white),),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Title: ${post.title}'),
                  Text('Body: ${post.body}'),
                  Text('Topics: ${post.topics.join(', ')}'),
                  if (post.images.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Images:'),
                    for (File image in post.images)
                      Image.file(
                        image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                  ],
                  if (post.videos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text('Videos:'),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int index = 0; index <
                                post.videos.length; index++)
                              Container(
                                height: 200,
                                child: Chewie(
                                  controller: ChewieController(
                                    videoPlayerController: VideoPlayerController
                                        .file(post.videos[index]),
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
                        child: Column(
                          children: [
                            for (String? url in post.urls)
                              FutureBuilder(
                                future: _fetchUrlContent(url!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Error fetching content from URL');
                                  } else if (snapshot.hasData) {
                                    String content = snapshot.data.toString();
                                    if (url.endsWith('.mp4')) {
                                      return Container(
                                        height: 200,
                                        child: Chewie(
                                          controller: ChewieController(
                                            videoPlayerController: VideoPlayerController
                                                .network(url),
                                            autoPlay: false,
                                            looping: false,
                                            aspectRatio: 16 / 9,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 200,
                                        child: WebView(
                                          initialUrl: url,
                                          javascriptMode: JavascriptMode
                                              .unrestricted,
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
                  Text('Public: ${post.isPublic}'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitPost(post);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllPostsPage(
                    ),
                  ),
                );
              },
              child: Text('Submit Post'),
            ),

          ],
        );
      },
    );
  }
  void _submitPost(Post post) {
    FirebaseService firebaseService = FirebaseService();

    firebaseService.submitPost(post);

    print('Post Submitted: ${post.title}');
  }


  Future<String?> _showDialog(String title) async {
    String? value = '';
    TextEditingController _textFieldController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _textFieldController,
            autofocus: true,
            onChanged: (newValue) {
              value = newValue;
            },
            onSubmitted: (submittedValue) {
              Navigator.of(context).pop(submittedValue);
            },
            decoration: const InputDecoration(
              hintText: 'https://google.com',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(value);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}
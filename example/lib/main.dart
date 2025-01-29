import 'package:dsf_video_player/dsf_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  VideoPlayerMediaKit.ensureInitialized(
    android:
        true, // default: false    -    dependency: media_kit_libs_android_video
    iOS: true, // default: false    -    dependency: media_kit_libs_ios_video
    macOS:
        true, // default: false    -    dependency: media_kit_libs_macos_video
    windows:
        true, // default: false    -    dependency: media_kit_libs_windows_video
    linux: true, // default: false    -    dependency: media_kit_libs_linux
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MOCK DEMO'),
      ),
      body: const DsfPlaylistPlayer(
        payload: null,
      ),
    );
  }
}

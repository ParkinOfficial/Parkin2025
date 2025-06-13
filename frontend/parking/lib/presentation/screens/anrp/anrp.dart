import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


class DetectionScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const DetectionScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _DetectionScreenState createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  String _output = 'Waiting for detection...';

  @override
  void initState() {
    super.initState();
    _initializeEverything();
  }

  Future<void> _initializeEverything() async {
    await _initCamera();
    await _runPythonScript();
  }

  Future<void> _initCamera() async {
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _cameraController.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print("Camera init error: $e");
    }
  }

  Future<String> _copyPythonAsset(String assetPath, String filename) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  Future<void> _runPythonScript() async {
    try {


      final result = await Process.run('python', ['../assets/anrp/main.py']);

      setState(() {
        _output = result.stdout.toString().isNotEmpty
            ? result.stdout
            : result.stderr.toString();
      });
    } catch (e) {
      setState(() {
        _output = "Python execution failed: $e";
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('License Plate Detection')),
      body: Column(
        children: [
          if (_isCameraInitialized)
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            )
          else
            Center(child: CircularProgressIndicator()),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Output: $_output"),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import 'result_page.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  bool _isLoading = true;
  List<XFile> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initialize();
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('Camera init failed: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_capturedImages.length >= 2) return;
    try {
      final image = await _cameraService.takePicture();
      setState(() => _capturedImages.add(image));
    } catch (e) {
      debugPrint('Failed to take picture: $e');
    }
  }

  void _resetImages() {
    setState(() => _capturedImages.clear());
  }

  void _goToResults() {
    if (_capturedImages.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture 2 images first.')),
      );
      return;
    }

    final imagePaths = _capturedImages.map((xfile) => xfile.path).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(imagePaths: imagePaths),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(title: const Text('Camera')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _cameraService.cameraPreview()),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text('Images Taken: ${_capturedImages.length}/2'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _takePicture,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _resetImages,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _capturedImages.length == 2
                                ? _goToResults
                                : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Results'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Small thumbnails preview
                      if (_capturedImages.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _capturedImages.map((xfile) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.file(
                                  File(xfile.path),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

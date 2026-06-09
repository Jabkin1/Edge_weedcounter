import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraService {
  late final CameraController _controller;
  bool _initialized = false;
  final double aspectRatio;

  CameraService({this.aspectRatio = 1.0}); // default square

  Future<void> initialize() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) throw Exception("No cameras found on device");

    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();
    _initialized = true;
  }

  bool get isReady {
    try {
      return _initialized && _controller.value.isInitialized;
    } catch (_) {
      return false;
    }
  }

  Future<XFile> takePicture() async {
    if (!_controller.value.isInitialized) {
      throw Exception('CameraController is not initialized.');
    }
    return _controller.takePicture();
  }

  Widget cameraPreview() {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.previewSize!.height,
                height: _controller.value.previewSize!.width,
                child: CameraPreview(_controller),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/camera_service.dart';
import '../gen_l10n/app_localizations.dart';
import 'result_page.dart';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraService? _cameraService;
  bool _isLoading = true;
  List<XFile> _capturedImages = [];
  final int _maxImages = 10;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera permission is required')),
            );
          }
          setState(() => _isLoading = false);
          return;
        }
      }

      final service = CameraService();
      await service.initialize();
      if (mounted) {
        setState(() {
          _cameraService = service;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Camera init failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize camera')),
        );
      }
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraService?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_capturedImages.length >= _maxImages) return;
    final service = _cameraService;
    if (service == null) return;
    try {
      final image = await service.takePicture();
      if (mounted) {
        setState(() => _capturedImages.add(image));
      }
    } catch (e) {
      debugPrint('Failed to take picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to take picture')),
        );
      }
    }
  }

  void _resetImages() {
    setState(() => _capturedImages.clear());
  }

  void _goToResults() {
    if (_capturedImages.length < _maxImages) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.imagesTaken(_capturedImages.length))),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(title: Text(l10n.cameraPage)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _cameraService == null
              ? const Center(child: Text('Camera not available'))
              : Column(
              children: [
                Expanded(child: _cameraService!.cameraPreview()),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(l10n.imagesTaken(_capturedImages.length)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _takePicture,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt),
                                const SizedBox(width: 4),
                                Text(l10n.capture),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _resetImages,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.refresh),
                                const SizedBox(width: 4),
                                Text(l10n.reset),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _capturedImages.length == _maxImages ? _goToResults : null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_forward),
                                const SizedBox(width: 4),
                                Text(l10n.processResults),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
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

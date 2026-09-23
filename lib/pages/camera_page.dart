import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../gen_l10n/app_localizations.dart';
import '../services/camera_service.dart';
import 'result_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  List<XFile> _capturedImages = [];
  int _selectedSource = 0;

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
    if (_capturedImages.length >= 5) return;
    try {
      final image = await _cameraService.takePicture();
      setState(() => _capturedImages.add(image));
    } catch (e) {
      debugPrint('Failed to take picture: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    if (_capturedImages.length >= 5) return;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _capturedImages.add(image));
      }
    } catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void _resetImages() {
    setState(() => _capturedImages.clear());
  }

  void _goToResults() {
    if (_capturedImages.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pleaseCapture5ImagesFirst)),);
      return;
    }
    final imagePaths = _capturedImages.map((xfile) => xfile.path).toList();
    Navigator.push(context, MaterialPageRoute( builder: (_) => ResultPage(imagePaths: imagePaths),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.camera)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_selectedSource == 0)
                  Expanded(child: _cameraService.cameraPreview())
                else
                  Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.pickImage, style: const TextStyle(fontSize: 16, color: Colors.grey),),),),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Source selector (Camera/Gallery)
                      SegmentedButton<int>(
                        segments: [
                          ButtonSegment(value: 0, icon: Icon(Icons.camera_alt), label: Text(AppLocalizations.of(context)!.camera)),
                          ButtonSegment(value: 1, icon: Icon(Icons.photo_library), label: Text(AppLocalizations.of(context)!.gallery)),
                        ],
                        selected: {_selectedSource},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() => _selectedSource = newSelection.first);
                        },
                      ),
                      const SizedBox(height: 16),

                      Text(AppLocalizations.of(context)!.imagesTaken(_capturedImages.length.toString())),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _selectedSource == 0 ? _takePicture : _pickFromGallery,
                            icon: Icon(_selectedSource == 0 ? Icons.camera_alt : Icons.photo_library,),
                            label: Text(_selectedSource == 0 ? AppLocalizations.of(context)!.capture : AppLocalizations.of(context)!.pickImage),
                          ),
                          ElevatedButton.icon(
                            onPressed: _resetImages,
                            icon: const Icon(Icons.refresh),
                            label: Text(AppLocalizations.of(context)!.reset),
                          ),
                          ElevatedButton.icon(
                            onPressed: _capturedImages.length == 5 ? _goToResults : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(AppLocalizations.of(context)!.results),
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
                                child: Image.file(File(xfile.path), width: 80, height: 80, fit: BoxFit.cover,),
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

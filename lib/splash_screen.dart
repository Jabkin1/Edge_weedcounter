import 'package:flutter/material.dart';
import 'dart:async';
import '../services/yolo_service.dart';
import '../services/camera_service.dart';

class AppServices {
  static final AppServices _instance = AppServices._internal();
  late final YoloService yoloService;
  late final CameraService cameraService;

  factory AppServices() => _instance;

  AppServices._internal();

  Future<void> preloadModelOnly() async {
    yoloService = YoloService();
    await yoloService.loadModel();
  }

  Future<void> initializeCamera() async {
    cameraService = CameraService();
    await cameraService.initialize();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFD7DAE0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 200),
                const SizedBox(height: 24),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

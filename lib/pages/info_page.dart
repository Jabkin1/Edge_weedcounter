import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Weed Counter+ v1.2\n\n'
            'This app helps you detect weed species and their coverage on fields. '
            'Use the camera to take 10 random images of the field, run the analysis in results and watch what to do in summary.\n\n',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w700,
              color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
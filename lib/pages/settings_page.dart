import 'package:flutter/material.dart';

import '../utils/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'English';
  String _selectedModel = 'Default Crop Model';

  final List<String> _availableLanguages = [
    'English',
    'German',
    'French'
  ];

  final List<String> _availableModels = [
    'Default Crop Model',
    'Corn Detection',
    'Wheat Analysis'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Preference',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _availableLanguages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Model Selection:\n Choose model to use for the detection, a larger model is preferred for a more accurate detection, but it might be difficult to run on all phones',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
                value: ModelSelection.selectedModel,
                items: ModelSelection.models.map((model) {
                  return DropdownMenuItem<String>(
                    value: model['name'],
                    child: Text(model['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  ModelSelection.selectedModel = value!;
                }),
            const SizedBox(height: 24),
            const Text(
              'Crop Model Selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedModel,
              items: _availableModels
                  .map((model) => DropdownMenuItem(
                        value: model,
                        child: Text(model),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedModel = value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

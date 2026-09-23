import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../utils/models.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'English';
  String _selectedModel = 'Default Crop Model';
  Locale _selectedLocale = const Locale('en');

  final List<Map<String, dynamic>> _availableLanguages = [
    {'name': 'English', 'locale': 'en'},
    {'name': 'German', 'locale': 'de'},
    {'name': 'French', 'locale': 'fr'}
  ];

  final List<String> _availableModels = [
    'Default Crop Model',
    'Corn Detection',
    'Wheat Analysis'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.languagePreference,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _availableLanguages
                  .map((lang) => DropdownMenuItem(
                        value: lang['name'] as String,
                        child: Text(lang['name'] as String),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final selectedLang = _availableLanguages.firstWhere(
                    (lang) => lang['name'] == value,
                    orElse: () => _availableLanguages[0],
                  );
                  setState(() {
                    _selectedLanguage = value;
                    _selectedLocale = Locale(selectedLang['locale'] as String);
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.modelSelection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            Text(
              AppLocalizations.of(context)!.cropModelSelection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

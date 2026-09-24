import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    {'name': 'Phone Default', 'locale': null},
    {'name': 'English', 'locale': 'en'},
    {'name': 'German', 'locale': 'de'},
    {'name': 'French', 'locale': 'fr'}
  ];
/*** Not implemented yet
  final List<String> _availableModels = [
    'Default Crop Model',
    'Corn Detection',
    'Wheat Analysis'
  ];
*/
  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', languageCode);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeStr = prefs.getString('app_locale');
    if (localeStr != null && localeStr.isNotEmpty) {
      setState(() {
        _selectedLocale = Locale(localeStr);
        final lang = _availableLanguages.firstWhere(
              (lang) => lang['locale'] == localeStr,
          orElse: () => _availableLanguages[3],
        );
        _selectedLanguage = lang['name'] as String;
      });
    } else {
      setState(() {
        _selectedLanguage = 'Phone Default';
        _selectedLocale = WidgetsBinding.instance.window.locale;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

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
              onChanged: (value) async{
                if (value != null) {
                  final selectedLang = _availableLanguages.firstWhere(
                    (lang) => lang['name'] == value,
                    orElse: () => _availableLanguages[0],
                  );
                  final localeCode = selectedLang['locale'] as String?;
                  if (localeCode != null) {
                    await _saveLocale(localeCode);
                  } else {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('app_locale');
                  }
                  setState(() {
                    _selectedLanguage = value;
                    _selectedLocale = localeCode != null ? Locale(localeCode) : WidgetsBinding.instance.window.locale;
                  });
                  if (!mounted) return;
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.settings),
                      content: Text('${AppLocalizations.of(context)!.languagePreference} ${AppLocalizations.of(context)!.select}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(AppLocalizations.of(context)!.select),
                        ),
                      ],
                    ),
                  );
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
            /*
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
            ),*/
          ],
        ),
      ),
    );
  }
}

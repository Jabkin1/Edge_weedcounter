import 'package:flutter/material.dart';
import '../gen_l10n/app_localizations.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedLanguage;

  final List<_LanguageOption> _languages = [
    _LanguageOption('English', 'en'),
    _LanguageOption('Français', 'fr'),
    _LanguageOption('Español', 'es'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = appLocale.languageCode == 'fr'
        ? 'Français'
        : appLocale.languageCode == 'es'
            ? 'Español'
            : 'English';
  }

  void _onLanguageChanged(String label) {
    final lang = _languages.firstWhere((l) => l.label == label);
    MyApp.setLocale(context, Locale(lang.code));
    setState(() => _selectedLanguage = label);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.languagePreference,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: _languages
                  .map((lang) => DropdownMenuItem(
                        value: lang.label,
                        child: Text(lang.label),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) _onLanguageChanged(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  final String label;
  final String code;
  const _LanguageOption(this.label, this.code);
}

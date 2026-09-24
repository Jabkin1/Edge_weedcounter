import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_routes.dart';
import 'gen_l10n/app_localizations.dart';
import 'utils/plant_data.dart';


//TODO: multiple model selection
//TODO: not there yet: more crops
//TODO: write documentation
const _kLocaleKey = 'app_locale';

Future<Locale?> _getSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final localeStr = prefs.getString(_kLocaleKey);
  if (localeStr != null) {
    final parts = localeStr.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }
  return null;
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final savedLocale = await _getSavedLocale();
  runApp( MyApp(savedLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;
  const MyApp({super.key,this.savedLocale});

  @override
  Widget build(BuildContext context) {
    plant_data.load();
    final locale = savedLocale ?? WidgetsBinding.instance.window.locale;
    return MaterialApp(
      title: 'Weed Counter+',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: AppLocalizations.supportedLocales.contains(locale) ? locale : null,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

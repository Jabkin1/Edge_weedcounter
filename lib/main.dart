import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_routes.dart';
import 'gen_l10n/app_localizations.dart';
import 'utils/plant_data.dart';


//TODO: multiple model selection
//TODO: not there yet: more crops
//TODO: write documentation
//TODO: Settings page: models, languages and model type.


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    plant_data.load();
    return MaterialApp(
      title: 'Weed Counter+',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'utils/plant_data.dart';


//TODO: multiple model selection
//TODO: not there yet: more crops
//TODO: write documentation


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
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

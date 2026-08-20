import 'package:flutter/material.dart';
import 'app_routes.dart'; // Make sure this matches your actual file path

//TODO: multiple modelmodel selection
//TODO: evaluation part different colors for different species,
//TODO: not there yet: more crops
//TODO: write documentation
// TODO: result summary page
//TODO: reset solni threshold in csv, reset to adequate values for detection

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weed Counter+',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

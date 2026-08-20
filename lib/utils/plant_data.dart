import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class plant_data {
  static List<Map<String, String>> _plants = [];

  static Future<void> load() async {
    final rawCSV_text = await rootBundle.loadString('assets/plants.csv');
    final rows = csv.decode(rawCSV_text);
    if (rows.isEmpty) throw Exception('plants.csv is empty');
    final headers = rows.first.map((e) => e.toString().trim()).toList();
    _plants = rows.skip(1).map((row) {
      return {for (int i = 0; i < headers.length && i < row.length; i++)headers[i]: row[i].toString().trim(),};}).toList();
    print('Loaded ${_plants.length} plants.');
  }

  static List<String> getLabels() {
    return _plants.map((plant) => plant['label'] ?? '').toList();
  }
  static List<String> getThresholds(){
    return _plants.map((plant)=> plant['Threshold'] ?? '').toList();
  }

  static String labelAt(int index) {
    return _plants[index]['label'] ?? '';
  }

  static Map<String, String>? getRow(String label) {
    try {
      return _plants.firstWhere((plant) => plant['label'] == label,);
    } catch (_) {return null;}
  }
  static String getValue(String label, String column) {
    final value = getRow(label)?[column];
    return value ?? '';
  }
  static double getThreshold(String label) {
    return double.parse(getValue(label, 'Threshold'));
  }
  static String getName(String label){
    return getValue(label,'Common Name');
  }
  static String getScientificName(String label){
    return getValue(label, 'Scientific name');
  }
  static Color getColor(String label){
    final value = getValue(label,'colour').replaceFirst('#', '');
    final argb = value.length == 6
        ? 'FF$value'
        : value;
    return Color(int.parse(argb, radix: 16));
  }
}
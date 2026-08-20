class ModelSelection {
  static const List<Map<String, String>> models = [
    {
      'name': 'Small',
      'path': 'assets/models/yolo.tflite',
    },
    {
      'name': 'Medium',
      'path': 'assets/models/yolo.tflite',
    },
    {
      'name': 'Large',
      'path': 'assets/models/yolo.tflite',
    },
  ];

  static String selectedModel = 'Small';

  static String get selectedModelPath {
    return models.firstWhere(
          (model) => model['name'] == selectedModel,
    )['path']!;
  }
}
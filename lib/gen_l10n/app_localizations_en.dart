// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get capture => 'Capture';

  @override
  String get reset => 'Reset';

  @override
  String get processResults => 'Process Results';

  @override
  String get returnHome => 'Return to Home';

  @override
  String get settings => 'Settings';

  @override
  String get cameraPage => 'Camera';

  @override
  String get detections => 'Detections';

  @override
  String get detectionSummary => 'Detection Summary';

  @override
  String get info => 'Info';

  @override
  String imagesTaken(Object count) {
    return 'Images Taken: $count/10';
  }

  @override
  String get noDetections => 'No detections found.';

  @override
  String get runDetection => 'Run Detection';

  @override
  String get viewSummary => 'View Summary';

  @override
  String get languagePreference => 'Language Preference';

  @override
  String get cropModelSelection => 'Crop Model Selection';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get spanish => 'Spanish';

  @override
  String get weedCounterVersion => 'Weed Counter+ version 1.2';

  @override
  String get infoDescription =>
      'This app helps you detect weed species and their coverage on fields. Use the camera to take 10 random images of the field, run the analysis in results and watch what to do in summary.';

  @override
  String countLabel(Object count) {
    return 'Count: $count';
  }

  @override
  String averageConfidence(Object percent) {
    return 'Average Confidence: $percent%';
  }

  @override
  String get noActionNeeded => 'No action needed';

  @override
  String get manualCheckRecommended => 'Manual check recommended';

  @override
  String get manageWeeds => 'Manage weeds';

  @override
  String get manageWeedsDesc => 'Control measures are advised';

  @override
  String get manualCheckDesc => 'Verify field conditions before deciding';

  @override
  String get areaLabel => 'Area surveyed';

  @override
  String get noDetectionsRecorded => 'No detections recorded';

  @override
  String percentOfThreshold(Object percent) {
    return '$percent% of threshold';
  }

  @override
  String get chipCount => 'Count';

  @override
  String get chipThreshold => 'Threshold';

  @override
  String get chipDensity => 'Density';

  @override
  String get retake => 'Retake';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get takePicturesFirst => 'Take pictures first!';
}

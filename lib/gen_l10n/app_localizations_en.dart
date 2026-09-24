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
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get detections => 'Detections';

  @override
  String get detectionSummary => 'Detection Summary';

  @override
  String get results => 'Results';

  @override
  String get summary => 'Summary';

  @override
  String get info => 'Info';

  @override
  String get settings => 'Settings';

  @override
  String get languagePreference => 'Language Preference';

  @override
  String get languageSelection => 'Language Changed. Please restart the Application';
  @override
  String get LanguageConfirm => 'Close';

  @override
  String get modelSelection =>
      'Model Selection:\n Choose model to use for the detection, a larger model is preferred for a more accurate detection, but it might be difficult to run on all phones';

  @override
  String get cropModelSelection => 'Crop Model Selection';

  @override
  String imagesTaken(Object count) {
    return 'Images Taken: $count/5';
  }

  @override
  String get noDetectionsFound => 'No detections found.';

  @override
  String get pleaseCapture5ImagesFirst => 'Please capture 5 images first.';

  @override
  String get runDetection => 'Run Detection';

  @override
  String get viewSummary => 'View Summary';

  @override
  String get select => 'Select';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get weedCounterVersion => 'Weed Counter+ version 1.2';

  @override
  String get weedCounterDescription =>
      'Weed Counter+ v1.2\n\nThis app helps you detect weed species and their coverage on fields. Use the camera to take 10 random images of the field, run the analysis in results and watch what to do in summary.\n\n';

  @override
  String get weedCoveragePerSpecies =>
      'Weed coverage per species (5 pictures = 2.5 m²)';

  @override
  String sampleInfo(Object area, Object pictures, Object total) {
    return 'Sample: $pictures of $total pictures · $area m²';
  }

  @override
  String densityText(Object density, Object threshold) {
    return 'Density: $density plants·m⁻²   |   ET: $threshold plants·m⁻²';
  }

  @override
  String detectedInfo(Object count, Object pictures) {
    return 'Detected: $count plants in $pictures pictures';
  }

  @override
  String get noInterventionRequired => 'No intervention required';

  @override
  String get manualVerificationAdvised => 'Manual verification advised';

  @override
  String get interventionRecommended => 'Intervention recommended';

  @override
  String get noInterventionMessage =>
      'All species are below their economic thresholds in the sampled area.';

  @override
  String get manualVerificationMessage =>
      'Coverage is within ±10% of the economic threshold for the species below.';

  @override
  String get interventionMessage =>
      'One or more weed species exceed their economic threshold in this sample.';

  @override
  String get coverageHeader => 'Coverage Header';

  @override
  String get noAction => 'No Action';

  @override
  String get borderline => 'Borderline';

  @override
  String get intervention => 'Intervention';

  @override
  String get pickImage => 'Pick Image';
}

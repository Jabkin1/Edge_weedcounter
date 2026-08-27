// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get capture => 'Capturer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get processResults => 'Traiter les résultats';

  @override
  String get returnHome => 'Retour à l\'accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get cameraPage => 'Appareil photo';

  @override
  String get detections => 'Détections';

  @override
  String get detectionSummary => 'Résumé des détections';

  @override
  String get info => 'Infos';

  @override
  String imagesTaken(Object count) {
    return 'Images prises : $count/10';
  }

  @override
  String get noDetections => 'Aucune détection trouvée.';

  @override
  String get runDetection => 'Lancer la détection';

  @override
  String get viewSummary => 'Voir le résumé';

  @override
  String get languagePreference => 'Préférence de langue';

  @override
  String get cropModelSelection => 'Sélection du modèle de culture';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get spanish => 'Espagnol';

  @override
  String get weedCounterVersion => 'Weed Counter+ version 1.2';

  @override
  String get infoDescription =>
      'Cette application vous aide à détecter les espèces de mauvaises herbes et leur couverture dans les champs. Utilisez l\'appareil photo pour prendre 10 images aléatoires du champ, lancez l\'analyse dans les résultats et consultez le résumé pour savoir quoi faire.';

  @override
  String countLabel(Object count) {
    return 'Comptage : $count';
  }

  @override
  String averageConfidence(Object percent) {
    return 'Confiance moyenne : $percent%';
  }

  @override
  String get noActionNeeded => 'Aucune action nécessaire';

  @override
  String get manualCheckRecommended => 'Vérification manuelle recommandée';

  @override
  String get manageWeeds => 'Gérer les mauvaises herbes';

  @override
  String get manageWeedsDesc => 'Des mesures de contrôle sont conseillées';

  @override
  String get manualCheckDesc =>
      'Vérifier les conditions du champ avant de décider';

  @override
  String get areaLabel => 'Zone relevée';

  @override
  String get noDetectionsRecorded => 'Aucune détection enregistrée';

  @override
  String percentOfThreshold(Object percent) {
    return '$percent% du seuil';
  }

  @override
  String get chipCount => 'Comptage';

  @override
  String get chipThreshold => 'Seuil';

  @override
  String get chipDensity => 'Densité';

  @override
  String get retake => 'Reprendre';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get takePicturesFirst => 'Prenez d\'abord des photos';
}

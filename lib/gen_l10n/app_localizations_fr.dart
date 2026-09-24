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
  String get camera => 'Caméra';

  @override
  String get gallery => 'Galerie';

  @override
  String get detections => 'Détections';

  @override
  String get detectionSummary => 'Résumé des détections';

  @override
  String get results => 'Résultats';

  @override
  String get summary => 'Résumé';

  @override
  String get info => 'Informations';

  @override
  String get settings => 'Paramètres';

  @override
  String get languagePreference => 'Préférence de langue';

  @override
  String get languageSelection => 'La langue a été modifiée. Veuillez redémarrer l\'application.';
  @override
  String get LanguageConfirm => 'Fermer';

  @override
  String get modelSelection =>
      'Sélection du modèle:\n Choisissez le modèle à utiliser pour la détection. Un modèle plus grand est préférable pour une détection plus précise, mais peut être difficile à exécuter sur tous les téléphones';

  @override
  String get cropModelSelection => 'Sélection du modèle de culture';

  @override
  String imagesTaken(Object count) {
    return 'Images capturées: $count/5';
  }

  @override
  String get noDetectionsFound => 'Aucune détection trouvée.';

  @override
  String get pleaseCapture5ImagesFirst =>
      'Veuillez capturer 5 images d\'abord.';

  @override
  String get runDetection => 'Lancer la détection';

  @override
  String get viewSummary => 'Voir le résumé';

  @override
  String get select => 'Sélectionner';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get weedCounterVersion => 'Compteur de mauvaises herbes+ version 1.2';

  @override
  String get weedCounterDescription =>
      'Compteur de mauvaises herbes+ v1.2\n\nCette application vous aide à détecter les espèces de mauvaises herbes et leur couverture sur les champs. Utilisez la caméra pour prendre 10 images aléatoires du champ, exécutez l\'analyse dans les résultats et voyez ce qu\'il faut faire dans le résumé.\n\n';

  @override
  String get weedCoveragePerSpecies =>
      'Couverture des mauvaises herbes par espèce (5 images = 2,5 m²)';

  @override
  String sampleInfo(Object area, Object pictures, Object total) {
    return 'Échantillon: $pictures sur $total images · $area m²';
  }

  @override
  String densityText(Object density, Object threshold) {
    return 'Densité: $density plantes·m⁻²   |   ST: $threshold plantes·m⁻²';
  }

  @override
  String detectedInfo(Object count, Object pictures) {
    return 'Détecté: $count plantes dans $pictures images';
  }

  @override
  String get noInterventionRequired => 'Aucune intervention nécessaire';

  @override
  String get manualVerificationAdvised => 'Vérification manuelle conseillée';

  @override
  String get interventionRecommended => 'Intervention recommandée';

  @override
  String get noInterventionMessage =>
      'Toutes les espèces sont en dessous de leurs seuils économiques dans la zone échantillonnée.';

  @override
  String get manualVerificationMessage =>
      'La couverture est dans ±10% du seuil économique pour les espèces ci-dessous.';

  @override
  String get interventionMessage =>
      'Une ou plusieurs espèces de mauvaises herbes dépassent leur seuil économique dans cet échantillon.';

  @override
  String get coverageHeader => 'En-tête de couverture';

  @override
  String get noAction => 'Aucune action';

  @override
  String get borderline => 'Limite';

  @override
  String get intervention => 'Intervention';

  @override
  String get pickImage => 'Choisir une image';
}

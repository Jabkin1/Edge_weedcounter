// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get capture => 'Aufnehmen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get processResults => 'Ergebnisse verarbeiten';

  @override
  String get returnHome => 'Zurück zur Startseite';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galerie';

  @override
  String get detections => 'Erkennungen';

  @override
  String get detectionSummary => 'Erkennungszusammenfassung';

  @override
  String get results => 'Ergebnisse';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get info => 'Info';

  @override
  String get settings => 'Einstellungen';

  @override
  String get languagePreference => 'Sprachpräferenz';

  @override
  String get languageSelection => 'Die Sprache wurde geändert. Bitte starten Sie die Anwendung neu.';
  @override
  String get LanguageConfirm => 'schließen';

  @override
  String get modelSelection =>
      'Modellauswahl:\n Wählen Sie das Modell für die Erkennung. Ein größeres Modell ist für eine genauere Erkennung bevorzugt, kann aber auf einigen Geräten schwierig auszuführen sein';

  @override
  String get cropModelSelection => 'Kulturpflanzen-Modellauswahl';

  @override
  String imagesTaken(Object count) {
    return 'Aufgenommene Bilder: $count/5';
  }

  @override
  String get noDetectionsFound => 'Keine Erkennungen gefunden.';

  @override
  String get pleaseCapture5ImagesFirst =>
      'Bitte nehmen Sie zuerst 5 Bilder auf.';

  @override
  String get runDetection => 'Erkennung starten';

  @override
  String get viewSummary => 'Zusammenfassung anzeigen';

  @override
  String get select => 'Auswählen';

  @override
  String get pageNotFound => 'Seite nicht gefunden';

  @override
  String get weedCounterVersion => 'Unkraut-Zähler+ Version 1.2';

  @override
  String get weedCounterDescription =>
      'Unkraut-Zähler+ v1.2\n\nDiese App hilft Ihnen, Unkrautarten und deren Verbreitung auf Feldern zu erkennen. Verwenden Sie die Kamera, um 10 zufällige Bilder vom Feld aufzunehmen, führen Sie die Analyse in den Ergebnissen durch und sehen Sie sich in der Zusammenfassung an, was zu tun ist.\n\n';

  @override
  String get weedCoveragePerSpecies =>
      'Unkrautbedeckung pro Art (5 Bilder = 2,5 m²)';

  @override
  String sampleInfo(Object area, Object pictures, Object total) {
    return 'Probe: $pictures von $total Bildern · $area m²';
  }

  @override
  String densityText(Object density, Object threshold) {
    return 'Dichte: $density Pflanzen·m⁻²   |   WT: $threshold Pflanzen·m⁻²';
  }

  @override
  String detectedInfo(Object count, Object pictures) {
    return 'Erkannt: $count Pflanzen in $pictures Bildern';
  }

  @override
  String get noInterventionRequired => 'Kein Eingriff erforderlich';

  @override
  String get manualVerificationAdvised => 'Manuelle Überprüfung empfohlen';

  @override
  String get interventionRecommended => 'Eingriff empfohlen';

  @override
  String get noInterventionMessage =>
      'Alle Arten liegen unter ihren wirtschaftlichen Schwellenwerten im beprobten Bereich.';

  @override
  String get manualVerificationMessage =>
      'Die Bedeckung liegt innerhalb von ±10% des wirtschaftlichen Schwellenwerts für die folgenden Arten.';

  @override
  String get interventionMessage =>
      'Eine oder mehrere Unkrautarten überschreiten ihren wirtschaftlichen Schwellenwert in dieser Probe.';

  @override
  String get coverageHeader => 'Bedeckungsüberschrift';

  @override
  String get noAction => 'Keine Aktion';

  @override
  String get borderline => 'Grenzfall';

  @override
  String get intervention => 'Eingriff';

  @override
  String get pickImage => 'Bild auswählen';
}

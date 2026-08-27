// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get capture => 'Capturar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get processResults => 'Procesar resultados';

  @override
  String get returnHome => 'Volver al inicio';

  @override
  String get settings => 'Configuración';

  @override
  String get cameraPage => 'Cámara';

  @override
  String get detections => 'Detecciones';

  @override
  String get detectionSummary => 'Resumen de detecciones';

  @override
  String get info => 'Información';

  @override
  String imagesTaken(Object count) {
    return 'Imágenes tomadas : $count/10';
  }

  @override
  String get noDetections => 'No se encontraron detecciones.';

  @override
  String get runDetection => 'Ejecutar detección';

  @override
  String get viewSummary => 'Ver resumen';

  @override
  String get languagePreference => 'Preferencia de idioma';

  @override
  String get cropModelSelection => 'Selección de modelo de cultivo';

  @override
  String get english => 'Inglés';

  @override
  String get french => 'Francés';

  @override
  String get spanish => 'Español';

  @override
  String get weedCounterVersion => 'Weed Counter+ versión 1.2';

  @override
  String get infoDescription =>
      'Esta aplicación te ayuda a detectar especies de malezas y su cobertura en los campos. Usa la cámara para tomar 10 imágenes aleatorias del campo, ejecuta el análisis en resultados y mira el resumen para saber qué hacer.';

  @override
  String countLabel(Object count) {
    return 'Recuento : $count';
  }

  @override
  String averageConfidence(Object percent) {
    return 'Confianza media : $percent%';
  }

  @override
  String get noActionNeeded => 'No se requiere acción';

  @override
  String get manualCheckRecommended => 'Revisión manual recomendada';

  @override
  String get manageWeeds => 'Gestionar malezas';

  @override
  String get manageWeedsDesc => 'Se aconsejan medidas de control';

  @override
  String get manualCheckDesc =>
      'Verificar las condiciones del campo antes de decidir';

  @override
  String get areaLabel => 'Área relevada';

  @override
  String get noDetectionsRecorded => 'No se registraron detecciones';

  @override
  String percentOfThreshold(Object percent) {
    return '$percent% del umbral';
  }

  @override
  String get chipCount => 'Recuento';

  @override
  String get chipThreshold => 'Umbral';

  @override
  String get chipDensity => 'Densidad';

  @override
  String get retake => 'Recapturar';

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String get takePicturesFirst => '¡Toma fotos primero!';
}

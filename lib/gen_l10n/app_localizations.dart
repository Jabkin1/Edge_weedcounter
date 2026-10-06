import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @processResults.
  ///
  /// In en, this message translates to:
  /// **'Process Results'**
  String get processResults;

  /// No description provided for @returnHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnHome;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @detections.
  ///
  /// In en, this message translates to:
  /// **'Detections'**
  String get detections;

  /// No description provided for @detectionSummary.
  ///
  /// In en, this message translates to:
  /// **'Detection Summary'**
  String get detectionSummary;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  String get languageSelection;
  String get LanguageConfirm;

  /// No description provided for @modelSelection.
  ///
  /// In en, this message translates to:
  /// **'Model Selection:\n Choose model to use for the detection, a larger model is preferred for a more accurate detection, but it might be difficult to run on all phones'**
  String get modelSelection;

  /// No description provided for @cropModelSelection.
  ///
  /// In en, this message translates to:
  /// **'Crop Model Selection'**
  String get cropModelSelection;

  /// No description provided for @imagesTaken.
  ///
  /// In en, this message translates to:
  /// **'Images Taken: {count}/5'**
  String imagesTaken(Object count);

  /// No description provided for @noDetectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No detections found.'**
  String get noDetectionsFound;

  /// No description provided for @pleaseCapture5ImagesFirst.
  ///
  /// In en, this message translates to:
  /// **'Please capture 5 images first.'**
  String get pleaseCapture5ImagesFirst;

  /// No description provided for @runDetection.
  ///
  /// In en, this message translates to:
  /// **'Run Detection'**
  String get runDetection;

  /// No description provided for @viewSummary.
  ///
  /// In en, this message translates to:
  /// **'View Summary'**
  String get viewSummary;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @weedCounterVersion.
  ///
  /// In en, this message translates to:
  /// **'Weed Counter+ version 1.2'**
  String get weedCounterVersion;

  /// No description provided for @weedCounterDescription.
  ///
  /// In en, this message translates to:
  /// **'Weed Counter+ v1.2\n\nThis app helps you detect weed species and their coverage on fields. Use the camera to take 10 random images of the field, run the analysis in results and watch what to do in summary.\n\n'**
  String get weedCounterDescription;

  /// No description provided for @weedCoveragePerSpecies.
  ///
  /// In en, this message translates to:
  /// **'Weed coverage per species (5 pictures = 2.5 m²)'**
  String get weedCoveragePerSpecies;

  /// No description provided for @sampleInfo.
  ///
  /// In en, this message translates to:
  /// **'Sample: {pictures} of {total} pictures · {area} m²'**
  String sampleInfo(Object area, Object pictures, Object total);

  /// No description provided for @densityText.
  ///
  /// In en, this message translates to:
  /// **'Density: {density} plants·m⁻²   |   ET: {threshold} plants·m⁻²'**
  String densityText(Object density, Object threshold);

  /// No description provided for @detectedInfo.
  ///
  /// In en, this message translates to:
  /// **'Detected: {count} plants in {pictures} pictures'**
  String detectedInfo(Object count, Object pictures);

  /// No description provided for @noInterventionRequired.
  ///
  /// In en, this message translates to:
  /// **'No intervention required'**
  String get noInterventionRequired;

  /// No description provided for @manualVerificationAdvised.
  ///
  /// In en, this message translates to:
  /// **'Manual verification advised'**
  String get manualVerificationAdvised;

  /// No description provided for @interventionRecommended.
  ///
  /// In en, this message translates to:
  /// **'Intervention recommended'**
  String get interventionRecommended;

  /// No description provided for @noInterventionMessage.
  ///
  /// In en, this message translates to:
  /// **'All species are below their economic thresholds in the sampled area.'**
  String get noInterventionMessage;

  /// No description provided for @manualVerificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Coverage is within ±10% of the economic threshold for the species below.'**
  String get manualVerificationMessage;

  /// No description provided for @interventionMessage.
  ///
  /// In en, this message translates to:
  /// **'One or more weed species exceed their economic threshold in this sample.'**
  String get interventionMessage;

  /// No description provided for @coverageHeader.
  ///
  /// In en, this message translates to:
  /// **'Coverage Header'**
  String get coverageHeader;

  /// No description provided for @noAction.
  ///
  /// In en, this message translates to:
  /// **'No Action'**
  String get noAction;

  /// No description provided for @borderline.
  ///
  /// In en, this message translates to:
  /// **'Borderline'**
  String get borderline;

  /// No description provided for @intervention.
  ///
  /// In en, this message translates to:
  /// **'Intervention'**
  String get intervention;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

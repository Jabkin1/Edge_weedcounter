import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('en'),
    Locale('es'),
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

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @cameraPage.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraPage;

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

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @imagesTaken.
  ///
  /// In en, this message translates to:
  /// **'Images Taken: {count}/10'**
  String imagesTaken(Object count);

  /// No description provided for @noDetections.
  ///
  /// In en, this message translates to:
  /// **'No detections found.'**
  String get noDetections;

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

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  /// No description provided for @cropModelSelection.
  ///
  /// In en, this message translates to:
  /// **'Crop Model Selection'**
  String get cropModelSelection;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @weedCounterVersion.
  ///
  /// In en, this message translates to:
  /// **'Weed Counter+ version 1.2'**
  String get weedCounterVersion;

  /// No description provided for @infoDescription.
  ///
  /// In en, this message translates to:
  /// **'This app helps you detect weed species and their coverage on fields. Use the camera to take 10 random images of the field, run the analysis in results and watch what to do in summary.'**
  String get infoDescription;

  /// No description provided for @countLabel.
  ///
  /// In en, this message translates to:
  /// **'Count: {count}'**
  String countLabel(Object count);

  /// No description provided for @averageConfidence.
  ///
  /// In en, this message translates to:
  /// **'Average Confidence: {percent}%'**
  String averageConfidence(Object percent);

  /// No description provided for @noActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'No action needed'**
  String get noActionNeeded;

  /// No description provided for @manualCheckRecommended.
  ///
  /// In en, this message translates to:
  /// **'Manual check recommended'**
  String get manualCheckRecommended;

  /// No description provided for @manageWeeds.
  ///
  /// In en, this message translates to:
  /// **'Manage weeds'**
  String get manageWeeds;

  /// No description provided for @manageWeedsDesc.
  ///
  /// In en, this message translates to:
  /// **'Control measures are advised'**
  String get manageWeedsDesc;

  /// No description provided for @manualCheckDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify field conditions before deciding'**
  String get manualCheckDesc;

  /// No description provided for @areaLabel.
  ///
  /// In en, this message translates to:
  /// **'Area surveyed'**
  String get areaLabel;

  /// No description provided for @noDetectionsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No detections recorded'**
  String get noDetectionsRecorded;

  /// No description provided for @percentOfThreshold.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of threshold'**
  String percentOfThreshold(Object percent);

  /// No description provided for @chipCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get chipCount;

  /// No description provided for @chipThreshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get chipThreshold;

  /// No description provided for @chipDensity.
  ///
  /// In en, this message translates to:
  /// **'Density'**
  String get chipDensity;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @takePicturesFirst.
  ///
  /// In en, this message translates to:
  /// **'Take pictures first!'**
  String get takePicturesFirst;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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

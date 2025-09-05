import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('el'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'#PROJECT MERCILESSNESS'**
  String get appTitle;

  /// No description provided for @navigationhome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationhome;

  /// No description provided for @navigationtimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get navigationtimeline;

  /// No description provided for @navigationmap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navigationmap;

  /// No description provided for @navigationfavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navigationfavorites;

  /// No description provided for @navigationprofile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navigationprofile;

  /// No description provided for @navigationdatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get navigationdatabase;

  /// No description provided for @navigationnews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navigationnews;

  /// No description provided for @navigationlogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navigationlogin;

  /// No description provided for @homenewsCard1Title.
  ///
  /// In en, this message translates to:
  /// **'80 Years Liberation of Athens'**
  String get homenewsCard1Title;

  /// No description provided for @homenewsCard2Title.
  ///
  /// In en, this message translates to:
  /// **'80 Years Liberation of Thessaloniki'**
  String get homenewsCard2Title;

  /// No description provided for @hometimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'TIMELINE'**
  String get hometimelineTitle;

  /// No description provided for @hometimelineDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find all historical events in Greece from 1941 to 1945.'**
  String get hometimelineDescription;

  /// No description provided for @homemapTitle.
  ///
  /// In en, this message translates to:
  /// **'MAP'**
  String get homemapTitle;

  /// No description provided for @homemapDescription.
  ///
  /// In en, this message translates to:
  /// **'Here you can find our map with all camp and memorial locations marked.'**
  String get homemapDescription;

  /// No description provided for @mapsearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get mapsearchHint;

  /// No description provided for @authwelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authwelcomeBack;

  /// No description provided for @authloginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authloginSubtitle;

  /// No description provided for @authemail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get authemail;

  /// No description provided for @authpassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authpassword;

  /// No description provided for @authlogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authlogin;

  /// No description provided for @authregister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authregister;

  /// No description provided for @authforgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authforgotPassword;

  /// No description provided for @authnoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get authnoAccount;

  /// No description provided for @authregisterNow.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get authregisterNow;

  /// No description provided for @authcreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get authcreateAccount;

  /// No description provided for @authfillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Fill in all fields to register'**
  String get authfillAllFields;

  /// No description provided for @authusername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authusername;

  /// No description provided for @authconfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authconfirmPassword;

  /// No description provided for @authalreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authalreadyHaveAccount;

  /// No description provided for @authloginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get authloginNow;

  /// No description provided for @authsignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get authsignInWithGoogle;

  /// No description provided for @authsignInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get authsignInWithApple;

  /// No description provided for @authsignInWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get authsignInWithFacebook;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get author;

  /// No description provided for @databasetitle.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get databasetitle;

  /// No description provided for @databasesearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get databasesearch;

  /// No description provided for @databasereset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get databasereset;

  /// No description provided for @databasename.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get databasename;

  /// No description provided for @databaseplace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get databaseplace;

  /// No description provided for @databaseyear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get databaseyear;

  /// No description provided for @databaseevent.
  ///
  /// In en, this message translates to:
  /// **'Event/Type'**
  String get databaseevent;

  /// No description provided for @databasenameHint.
  ///
  /// In en, this message translates to:
  /// **'Name of victims, commanders or camps'**
  String get databasenameHint;

  /// No description provided for @databaseplaceHint.
  ///
  /// In en, this message translates to:
  /// **'Camp location, birth/death place'**
  String get databaseplaceHint;

  /// No description provided for @databaseyearHint.
  ///
  /// In en, this message translates to:
  /// **'Birth/death/opening/liberation year'**
  String get databaseyearHint;

  /// No description provided for @databaseeventHint.
  ///
  /// In en, this message translates to:
  /// **'Camp type, fate, profession, religion'**
  String get databaseeventHint;

  /// Anzahl der Suchergebnisse
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{result} other{results}} found'**
  String databaseresults(int count);

  /// No description provided for @databasenoresults.
  ///
  /// In en, this message translates to:
  /// **'Enter search terms and press \'Search\''**
  String get databasenoresults;

  /// No description provided for @databasesortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by: {option}'**
  String databasesortBy(String option);

  /// No description provided for @databasesortOptionsnameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get databasesortOptionsnameAsc;

  /// No description provided for @databasesortOptionsnameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name (Z-A)'**
  String get databasesortOptionsnameDesc;

  /// No description provided for @databasesortOptionsdateAsc.
  ///
  /// In en, this message translates to:
  /// **'Date (old-new)'**
  String get databasesortOptionsdateAsc;

  /// No description provided for @databasesortOptionsdateDesc.
  ///
  /// In en, this message translates to:
  /// **'Date (new-old)'**
  String get databasesortOptionsdateDesc;

  /// No description provided for @databasesortOptionstypeAsc.
  ///
  /// In en, this message translates to:
  /// **'Type (A-Z)'**
  String get databasesortOptionstypeAsc;

  /// No description provided for @databasesortOptionstypeDesc.
  ///
  /// In en, this message translates to:
  /// **'Type (Z-A)'**
  String get databasesortOptionstypeDesc;

  /// No description provided for @favoritestitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritestitle;

  /// No description provided for @favoritesnoFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesnoFavorites;

  /// No description provided for @favoritesnoFavoritesDescription.
  ///
  /// In en, this message translates to:
  /// **'Mark entries in the database as favorites to see them here.'**
  String get favoritesnoFavoritesDescription;

  /// No description provided for @favoritesloginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in to set favorites.'**
  String get favoritesloginRequired;

  /// No description provided for @favoritesaddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoritesaddedToFavorites;

  /// No description provided for @favoritesremovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favoritesremovedFromFavorites;

  /// No description provided for @favoritesall.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get favoritesall;

  /// No description provided for @favoritesvictims.
  ///
  /// In en, this message translates to:
  /// **'Victims'**
  String get favoritesvictims;

  /// No description provided for @favoritescamps.
  ///
  /// In en, this message translates to:
  /// **'Camps'**
  String get favoritescamps;

  /// No description provided for @favoritescommanders.
  ///
  /// In en, this message translates to:
  /// **'Commanders'**
  String get favoritescommanders;

  /// No description provided for @profiletitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profiletitle;

  /// No description provided for @profileaccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get profileaccountSettings;

  /// No description provided for @profileactions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get profileactions;

  /// No description provided for @profileverifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get profileverifyEmail;

  /// No description provided for @profilechangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get profilechangePassword;

  /// No description provided for @profileaccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get profileaccountInfo;

  /// No description provided for @profilelogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profilelogout;

  /// No description provided for @profiledeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profiledeleteAccount;

  /// No description provided for @profileverified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileverified;

  /// No description provided for @profilenotVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get profilenotVerified;

  /// No description provided for @profileupdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get profileupdateStatus;

  /// No description provided for @profilelogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out?'**
  String get profilelogoutConfirm;

  /// No description provided for @profiledeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get profiledeleteConfirm;

  /// No description provided for @admindashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get admindashboard;

  /// No description provided for @adminvictims.
  ///
  /// In en, this message translates to:
  /// **'Victims'**
  String get adminvictims;

  /// No description provided for @admincamps.
  ///
  /// In en, this message translates to:
  /// **'Camps'**
  String get admincamps;

  /// No description provided for @admincommanders.
  ///
  /// In en, this message translates to:
  /// **'Commanders'**
  String get admincommanders;

  /// No description provided for @adminaddNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get adminaddNew;

  /// No description provided for @adminedit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminedit;

  /// No description provided for @admindelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get admindelete;

  /// No description provided for @adminsave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminsave;

  /// No description provided for @admincancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admincancel;

  /// No description provided for @adminconfirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this entry? This action cannot be undone.'**
  String get adminconfirmDelete;

  /// No description provided for @timelineeventsoct28_1940.
  ///
  /// In en, this message translates to:
  /// **'Italian invasion of Greece'**
  String get timelineeventsoct28_1940;

  /// No description provided for @timelineeventsapr_1941.
  ///
  /// In en, this message translates to:
  /// **'German Wehrmacht starts the Balkan campaign'**
  String get timelineeventsapr_1941;

  /// No description provided for @timelineeventssummer_1941.
  ///
  /// In en, this message translates to:
  /// **'Beginning of the Great Famine'**
  String get timelineeventssummer_1941;

  /// No description provided for @timelineeventssep_1941.
  ///
  /// In en, this message translates to:
  /// **'Formation of the first organized resistance groups'**
  String get timelineeventssep_1941;

  /// No description provided for @timelineeventsnov_1942.
  ///
  /// In en, this message translates to:
  /// **'Operation Harling: Destruction of Gorgopotamos Bridge'**
  String get timelineeventsnov_1942;

  /// No description provided for @timelineeventsmar24_1943.
  ///
  /// In en, this message translates to:
  /// **'Domeniko massacre (Thessaly)'**
  String get timelineeventsmar24_1943;

  /// No description provided for @timelineeventsaug17_1943.
  ///
  /// In en, this message translates to:
  /// **'Destruction of the Jewish community of Thessaloniki'**
  String get timelineeventsaug17_1943;

  /// No description provided for @timelineeventssep14_1943.
  ///
  /// In en, this message translates to:
  /// **'Italian capitulation'**
  String get timelineeventssep14_1943;

  /// No description provided for @timelineeventsoct17_1943.
  ///
  /// In en, this message translates to:
  /// **'Viannos massacre (Crete)'**
  String get timelineeventsoct17_1943;

  /// No description provided for @timelineeventsjun29_1944.
  ///
  /// In en, this message translates to:
  /// **'Distomo massacre'**
  String get timelineeventsjun29_1944;

  /// No description provided for @timelineeventsoct12_1944.
  ///
  /// In en, this message translates to:
  /// **'Liberation of Athens'**
  String get timelineeventsoct12_1944;

  /// No description provided for @timelineeventsdec28_1944.
  ///
  /// In en, this message translates to:
  /// **'Dekemvriana: Street battles in Athens'**
  String get timelineeventsdec28_1944;

  /// No description provided for @timelineeventsfeb12_1945.
  ///
  /// In en, this message translates to:
  /// **'Varkiza Agreement'**
  String get timelineeventsfeb12_1945;

  /// No description provided for @newstitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get newstitle;

  /// No description provided for @newsathens.
  ///
  /// In en, this message translates to:
  /// **'Athens'**
  String get newsathens;

  /// No description provided for @newsthessaloniki.
  ///
  /// In en, this message translates to:
  /// **'Thessaloniki'**
  String get newsthessaloniki;

  /// No description provided for @newsliberation80Years.
  ///
  /// In en, this message translates to:
  /// **'80 Years Liberation'**
  String get newsliberation80Years;

  /// No description provided for @newsjumpToArticle.
  ///
  /// In en, this message translates to:
  /// **'Jump to article'**
  String get newsjumpToArticle;

  /// No description provided for @newsscrollToTop.
  ///
  /// In en, this message translates to:
  /// **'To the top'**
  String get newsscrollToTop;

  /// No description provided for @newstoggleArticle.
  ///
  /// In en, this message translates to:
  /// **'To other article'**
  String get newstoggleArticle;

  /// No description provided for @commonloading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonloading;

  /// No description provided for @commonerror.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonerror;

  /// No description provided for @commonsuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonsuccess;

  /// No description provided for @commonconfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonconfirm;

  /// No description provided for @commoncancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commoncancel;

  /// No description provided for @commonsave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonsave;

  /// No description provided for @commondelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commondelete;

  /// No description provided for @commonedit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonedit;

  /// No description provided for @commonadd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonadd;

  /// No description provided for @commonsearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonsearch;

  /// No description provided for @commonfilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonfilter;

  /// No description provided for @commonsort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get commonsort;

  /// No description provided for @commonclose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonclose;

  /// No description provided for @commonback.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonback;

  /// No description provided for @commonnext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonnext;

  /// No description provided for @commonprevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get commonprevious;

  /// No description provided for @commonyes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonyes;

  /// No description provided for @commonno.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonno;

  /// No description provided for @commonok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonok;

  /// No description provided for @commonunknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonunknown;

  /// No description provided for @commonoptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonoptional;

  /// No description provided for @commonrequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonrequired;

  /// No description provided for @commonhideSearch.
  ///
  /// In en, this message translates to:
  /// **'Hide search'**
  String get commonhideSearch;

  /// No description provided for @commonshowSearch.
  ///
  /// In en, this message translates to:
  /// **'Show search'**
  String get commonshowSearch;

  /// No description provided for @commonnoImage.
  ///
  /// In en, this message translates to:
  /// **'No image available'**
  String get commonnoImage;

  /// No description provided for @commonimageLoadError.
  ///
  /// In en, this message translates to:
  /// **'Image could not be loaded'**
  String get commonimageLoadError;

  /// No description provided for @validationrequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationrequired;

  /// No description provided for @validationinvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationinvalidEmail;

  /// No description provided for @validationpasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get validationpasswordTooShort;

  /// No description provided for @validationpasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationpasswordsDoNotMatch;

  /// No description provided for @validationusernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 4 and 10 characters long'**
  String get validationusernameTooShort;

  /// No description provided for @drawerhome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerhome;

  /// No description provided for @drawerdatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get drawerdatabase;

  /// No description provided for @drawernews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get drawernews;

  /// No description provided for @drawertimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get drawertimeline;

  /// No description provided for @drawermap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get drawermap;

  /// No description provided for @drawerfavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get drawerfavorites;

  /// No description provided for @drawerprofile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerprofile;

  /// No description provided for @draweradminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get draweradminDashboard;

  /// No description provided for @draweradministrator.
  ///
  /// In en, this message translates to:
  /// **'ADMINISTRATOR'**
  String get draweradministrator;

  /// No description provided for @draweradminPermissionActive.
  ///
  /// In en, this message translates to:
  /// **'Admin permission active'**
  String get draweradminPermissionActive;

  /// No description provided for @drawerfullAccess.
  ///
  /// In en, this message translates to:
  /// **'Full access to all administrative functions'**
  String get drawerfullAccess;

  /// No description provided for @drawernotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get drawernotLoggedIn;

  /// No description provided for @drawerloginForMoreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Sign in for more features'**
  String get drawerloginForMoreFeatures;

  /// No description provided for @loadingNavigation.
  ///
  /// In en, this message translates to:
  /// **'Loading navigation...'**
  String get loadingNavigation;

  /// No description provided for @loadingDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database is being reloaded...'**
  String get loadingDatabase;

  /// No description provided for @errorRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get errorRetryButton;

  /// No description provided for @errorLoadingNavigation.
  ///
  /// In en, this message translates to:
  /// **'Error loading navigation: {error}'**
  String errorLoadingNavigation(String error);

  /// No description provided for @errorDatabaseLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must log in to access the database.'**
  String get errorDatabaseLoginRequired;

  /// No description provided for @errorAdminLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must log in to access the admin dashboard.'**
  String get errorAdminLoginRequired;

  /// No description provided for @errorAdminPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have admin permission for this feature.'**
  String get errorAdminPermissionRequired;

  /// No description provided for @errorRepositoryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Repository not available. Please reload the app.'**
  String get errorRepositoryUnavailable;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'User email'**
  String get userEmail;

  /// No description provided for @unknownEmail.
  ///
  /// In en, this message translates to:
  /// **'Unknown email'**
  String get unknownEmail;

  /// No description provided for @adminBadge.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get adminBadge;

  /// No description provided for @adminPermissionActiveShort.
  ///
  /// In en, this message translates to:
  /// **'Admin active'**
  String get adminPermissionActiveShort;

  /// No description provided for @languageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSwitch;

  /// No description provided for @languageSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSwitchSubtitle;

  /// No description provided for @languageDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get languageDialogTitle;

  /// No description provided for @languageDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get languageDialogClose;

  /// No description provided for @desktopUserInfo.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get desktopUserInfo;

  /// No description provided for @mobileDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get mobileDrawerTitle;

  /// No description provided for @tabletLayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Tablet View'**
  String get tabletLayoutTitle;

  /// No description provided for @accessibilityNavigationHome.
  ///
  /// In en, this message translates to:
  /// **'Navigate to home'**
  String get accessibilityNavigationHome;

  /// No description provided for @accessibilityNavigationTimeline.
  ///
  /// In en, this message translates to:
  /// **'Navigate to timeline'**
  String get accessibilityNavigationTimeline;

  /// No description provided for @accessibilityNavigationMap.
  ///
  /// In en, this message translates to:
  /// **'Navigate to map'**
  String get accessibilityNavigationMap;

  /// No description provided for @accessibilityNavigationFavorites.
  ///
  /// In en, this message translates to:
  /// **'Navigate to favorites'**
  String get accessibilityNavigationFavorites;

  /// No description provided for @accessibilityNavigationProfile.
  ///
  /// In en, this message translates to:
  /// **'Navigate to profile'**
  String get accessibilityNavigationProfile;

  /// No description provided for @accessibilityLanguageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get accessibilityLanguageSwitch;

  /// No description provided for @accessibilityAdminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin panel access'**
  String get accessibilityAdminPanel;

  /// No description provided for @navigationRailExtend.
  ///
  /// In en, this message translates to:
  /// **'Extend navigation'**
  String get navigationRailExtend;

  /// No description provided for @navigationRailCollapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse navigation'**
  String get navigationRailCollapse;

  /// No description provided for @quickAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccessTitle;

  /// No description provided for @adminStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Statistics'**
  String get adminStatsTitle;

  /// No description provided for @verificationStatus.
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// No description provided for @adminDashboardTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open admin dashboard'**
  String get adminDashboardTooltip;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

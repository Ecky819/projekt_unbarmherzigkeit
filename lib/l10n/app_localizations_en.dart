// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '#PROJEKT UNBARMHERZIGKEIT';

  @override
  String get navigationhome => 'Home';

  @override
  String get navigationtimeline => 'Timeline';

  @override
  String get navigationmap => 'Map';

  @override
  String get navigationfavorites => 'Favorites';

  @override
  String get navigationprofile => 'Profile';

  @override
  String get navigationdatabase => 'Database';

  @override
  String get navigationnews => 'News';

  @override
  String get navigationlogin => 'Login';

  @override
  String get homenewsCard1Title => '80 Years Liberation of Athens';

  @override
  String get homenewsCard2Title => '80 Years Liberation of Thessaloniki';

  @override
  String get hometimelineTitle => 'TIMELINE';

  @override
  String get hometimelineDescription =>
      'Here you can find all historical events in Greece from 1941 to 1945.';

  @override
  String get homemapTitle => 'MAP';

  @override
  String get homemapDescription =>
      'Here you can find our map with all camp locations marked.';

  @override
  String get authwelcomeBack => 'Welcome back';

  @override
  String get authloginSubtitle => 'Sign in to continue';

  @override
  String get authemail => 'Email address';

  @override
  String get authpassword => 'Password';

  @override
  String get authlogin => 'Login';

  @override
  String get authregister => 'Register';

  @override
  String get authforgotPassword => 'Forgot password?';

  @override
  String get authnoAccount => 'Don\'t have an account?';

  @override
  String get authregisterNow => 'Register now';

  @override
  String get authcreateAccount => 'Create new account';

  @override
  String get authfillAllFields => 'Fill in all fields to register';

  @override
  String get authusername => 'Username';

  @override
  String get authconfirmPassword => 'Confirm password';

  @override
  String get authalreadyHaveAccount => 'Already have an account?';

  @override
  String get authloginNow => 'Login now';

  @override
  String get authsignInWithGoogle => 'Sign in with Google';

  @override
  String get authsignInWithApple => 'Sign in with Apple';

  @override
  String get authsignInWithFacebook => 'Sign in with Facebook';

  @override
  String get author => 'or';

  @override
  String get databasetitle => 'Database';

  @override
  String get databasesearch => 'Search';

  @override
  String get databasereset => 'Reset';

  @override
  String get databasename => 'Name';

  @override
  String get databaseplace => 'Place';

  @override
  String get databaseyear => 'Year';

  @override
  String get databaseevent => 'Event/Type';

  @override
  String get databasenameHint => 'Name of victims, commanders or camps';

  @override
  String get databaseplaceHint => 'Camp location, birth/death place';

  @override
  String get databaseyearHint => 'Birth/death/opening/liberation year';

  @override
  String get databaseeventHint => 'Camp type, fate, profession, religion';

  @override
  String databaseresults(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'results',
      one: 'result',
    );
    return '$count $_temp0 found';
  }

  @override
  String get databasenoresults => 'Enter search terms and press \'Search\'';

  @override
  String databasesortBy(Object option) {
    return 'Sort by: $option';
  }

  @override
  String get databasesortOptionsnameAsc => 'Name (A-Z)';

  @override
  String get databasesortOptionsnameDesc => 'Name (Z-A)';

  @override
  String get databasesortOptionsdateAsc => 'Date (old-new)';

  @override
  String get databasesortOptionsdateDesc => 'Date (new-old)';

  @override
  String get databasesortOptionstypeAsc => 'Type (A-Z)';

  @override
  String get databasesortOptionstypeDesc => 'Type (Z-A)';

  @override
  String get favoritestitle => 'Favorites';

  @override
  String get favoritesnoFavorites => 'No favorites yet';

  @override
  String get favoritesnoFavoritesDescription =>
      'Mark entries in the database as favorites to see them here.';

  @override
  String get favoritesloginRequired =>
      'You must be logged in to set favorites.';

  @override
  String get favoritesaddedToFavorites => 'Added to favorites';

  @override
  String get favoritesremovedFromFavorites => 'Removed from favorites';

  @override
  String get favoritesall => 'All';

  @override
  String get favoritesvictims => 'Victims';

  @override
  String get favoritescamps => 'Camps';

  @override
  String get favoritescommanders => 'Commanders';

  @override
  String get profiletitle => 'Profile';

  @override
  String get profileaccountSettings => 'Account Settings';

  @override
  String get profileactions => 'Actions';

  @override
  String get profileverifyEmail => 'Verify email';

  @override
  String get profilechangePassword => 'Change password';

  @override
  String get profileaccountInfo => 'Account information';

  @override
  String get profilelogout => 'Logout';

  @override
  String get profiledeleteAccount => 'Delete account';

  @override
  String get profileverified => 'Verified';

  @override
  String get profilenotVerified => 'Not verified';

  @override
  String get profileupdateStatus => 'Update status';

  @override
  String get profilelogoutConfirm => 'Do you really want to log out?';

  @override
  String get profiledeleteConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get admindashboard => 'Admin Dashboard';

  @override
  String get adminvictims => 'Victims';

  @override
  String get admincamps => 'Camps';

  @override
  String get admincommanders => 'Commanders';

  @override
  String get adminaddNew => 'Add new';

  @override
  String get adminedit => 'Edit';

  @override
  String get admindelete => 'Delete';

  @override
  String get adminsave => 'Save';

  @override
  String get admincancel => 'Cancel';

  @override
  String get adminconfirmDelete =>
      'Do you really want to delete this entry? This action cannot be undone.';

  @override
  String get timelineeventsoct28_1940 => 'Italian invasion of Greece';

  @override
  String get timelineeventsapr_1941 =>
      'German Wehrmacht starts the Balkan campaign';

  @override
  String get timelineeventssummer_1941 => 'Beginning of the Great Famine';

  @override
  String get timelineeventssep_1941 =>
      'Formation of the first organized resistance groups';

  @override
  String get timelineeventsnov_1942 =>
      'Operation Harling: Destruction of Gorgopotamos Bridge';

  @override
  String get timelineeventsmar24_1943 => 'Domeniko massacre (Thessaly)';

  @override
  String get timelineeventsaug17_1943 =>
      'Destruction of the Jewish community of Thessaloniki';

  @override
  String get timelineeventssep14_1943 => 'Italian capitulation';

  @override
  String get timelineeventsoct17_1943 => 'Viannos massacre (Crete)';

  @override
  String get timelineeventsjun29_1944 => 'Distomo massacre';

  @override
  String get timelineeventsoct12_1944 => 'Liberation of Athens';

  @override
  String get timelineeventsdec28_1944 =>
      'Dekemvriana: Street battles in Athens';

  @override
  String get timelineeventsfeb12_1945 => 'Varkiza Agreement';

  @override
  String get newstitle => 'News';

  @override
  String get newsathens => 'Athens';

  @override
  String get newsthessaloniki => 'Thessaloniki';

  @override
  String get newsliberation80Years => '80 Years Liberation';

  @override
  String get newsjumpToArticle => 'Jump to article';

  @override
  String get newsscrollToTop => 'To the top';

  @override
  String get newstoggleArticle => 'To other article';

  @override
  String get commonloading => 'Loading...';

  @override
  String get commonerror => 'Error';

  @override
  String get commonsuccess => 'Success';

  @override
  String get commonconfirm => 'Confirm';

  @override
  String get commoncancel => 'Cancel';

  @override
  String get commonsave => 'Save';

  @override
  String get commondelete => 'Delete';

  @override
  String get commonedit => 'Edit';

  @override
  String get commonadd => 'Add';

  @override
  String get commonsearch => 'Search';

  @override
  String get commonfilter => 'Filter';

  @override
  String get commonsort => 'Sort';

  @override
  String get commonclose => 'Close';

  @override
  String get commonback => 'Back';

  @override
  String get commonnext => 'Next';

  @override
  String get commonprevious => 'Previous';

  @override
  String get commonyes => 'Yes';

  @override
  String get commonno => 'No';

  @override
  String get commonok => 'OK';

  @override
  String get commonunknown => 'Unknown';

  @override
  String get commonoptional => 'Optional';

  @override
  String get commonrequired => 'Required';

  @override
  String get commonhideSearch => 'Hide search';

  @override
  String get commonshowSearch => 'Show search';

  @override
  String get commonnoImage => 'No image available';

  @override
  String get commonimageLoadError => 'Image could not be loaded';

  @override
  String get validationrequired => 'This field is required';

  @override
  String get validationinvalidEmail => 'Please enter a valid email address';

  @override
  String get validationpasswordTooShort =>
      'Password must be at least 8 characters long';

  @override
  String get validationpasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get validationusernameTooShort =>
      'Username must be between 4 and 10 characters long';

  @override
  String get drawerhome => 'Home';

  @override
  String get drawerdatabase => 'Database';

  @override
  String get drawernews => 'News';

  @override
  String get drawertimeline => 'Timeline';

  @override
  String get drawermap => 'Map';

  @override
  String get drawerfavorites => 'Favorites';

  @override
  String get drawerprofile => 'Profile';

  @override
  String get draweradminDashboard => 'Admin Dashboard';

  @override
  String get draweradministrator => 'ADMINISTRATOR';

  @override
  String get draweradminPermissionActive => 'Admin permission active';

  @override
  String get drawerfullAccess => 'Full access to all administrative functions';

  @override
  String get drawernotLoggedIn => 'Not logged in';

  @override
  String get drawerloginForMoreFeatures => 'Sign in for more features';
}

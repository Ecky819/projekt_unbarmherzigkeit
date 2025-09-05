// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => '#ΕΡΓΟ ΑΜΕΙΛΙΚΤΟΤΗΤΑ';

  @override
  String get navigationhome => 'Αρχική';

  @override
  String get navigationtimeline => 'Χρονολόγιο';

  @override
  String get navigationmap => 'Χάρτης';

  @override
  String get navigationfavorites => 'Αγαπημένα';

  @override
  String get navigationprofile => 'Προφίλ';

  @override
  String get navigationdatabase => 'Βάση Δεδομένων';

  @override
  String get navigationnews => 'Νέα';

  @override
  String get navigationlogin => 'Σύνδεση';

  @override
  String get homenewsCard1Title => '80 Χρόνια Απελευθέρωσης Αθηνών';

  @override
  String get homenewsCard2Title => '80 Χρόνια Απελευθέρωσης Θεσσαλονίκης';

  @override
  String get hometimelineTitle => 'ΧΡΟΝΟΛΟΓΙΟ';

  @override
  String get hometimelineDescription => 'Εδώ μπορείτε να βρείτε όλα τα ιστορικά γεγονότα στην Ελλάδα από το 1941 έως το 1945.';

  @override
  String get homemapTitle => 'ΧΑΡΤΗΣ';

  @override
  String get homemapDescription => 'Εδώ μπορείτε να βρείτε το χάρτη μας με σημειωμένες όλες τις τοποθεσίες των κατασκηνώσεων';

  @override
  String get mapsearchHint => 'Αναζήτηση';

  @override
  String get authwelcomeBack => 'Καλώς ήρθατε πίσω';

  @override
  String get authloginSubtitle => 'Συνδεθείτε για να συνεχίσετε';

  @override
  String get authemail => 'Διεύθυνση email';

  @override
  String get authpassword => 'Κωδικός πρόσβασης';

  @override
  String get authlogin => 'Σύνδεση';

  @override
  String get authregister => 'Εγγραφή';

  @override
  String get authforgotPassword => 'Ξεχάσατε τον κωδικό;';

  @override
  String get authnoAccount => 'Δεν έχετε λογαριασμό;';

  @override
  String get authregisterNow => 'Εγγραφείτε τώρα';

  @override
  String get authcreateAccount => 'Δημιουργία νέου λογαριασμού';

  @override
  String get authfillAllFields => 'Συμπληρώστε όλα τα πεδία για εγγραφή';

  @override
  String get authusername => 'Όνομα χρήστη';

  @override
  String get authconfirmPassword => 'Επιβεβαίωση κωδικού';

  @override
  String get authalreadyHaveAccount => 'Έχετε ήδη λογαριασμό;';

  @override
  String get authloginNow => 'Συνδεθείτε τώρα';

  @override
  String get authsignInWithGoogle => 'Σύνδεση με Google';

  @override
  String get authsignInWithApple => 'Σύνδεση με Apple';

  @override
  String get authsignInWithFacebook => 'Σύνδεση με Facebook';

  @override
  String get author => 'ή';

  @override
  String get databasetitle => 'Βάση Δεδομένων';

  @override
  String get databasesearch => 'Αναζήτηση';

  @override
  String get databasereset => 'Επαναφορά';

  @override
  String get databasename => 'Όνομα';

  @override
  String get databaseplace => 'Τόπος';

  @override
  String get databaseyear => 'Έτος';

  @override
  String get databaseevent => 'Γεγονός/Τύπος';

  @override
  String get databasenameHint => 'Όνομα θυμάτων, διοικητών ή στρατοπέδων';

  @override
  String get databaseplaceHint => 'Τοποθεσία στρατοπέδου, τόπος γέννησης/θανάτου';

  @override
  String get databaseyearHint => 'Έτος γέννησης/θανάτου/ανοίγματος/απελευθέρωσης';

  @override
  String get databaseeventHint => 'Τύπος στρατοπέδου, μοίρα, επάγγελμα, θρησκεία';

  @override
  String databaseresults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'αποτελέσματα',
      one: 'αποτέλεσμα',
    );
    return '$count $_temp0 βρέθηκαν';
  }

  @override
  String get databasenoresults => 'Εισάγετε όρους αναζήτησης και πατήστε \'Αναζήτηση\'';

  @override
  String databasesortBy(String option) {
    return 'Ταξινόμηση κατά: $option';
  }

  @override
  String get databasesortOptionsnameAsc => 'Όνομα (Α-Ω)';

  @override
  String get databasesortOptionsnameDesc => 'Όνομα (Ω-Α)';

  @override
  String get databasesortOptionsdateAsc => 'Ημερομηνία (παλιό-νέο)';

  @override
  String get databasesortOptionsdateDesc => 'Ημερομηνία (νέο-παλιό)';

  @override
  String get databasesortOptionstypeAsc => 'Τύπος (Α-Ω)';

  @override
  String get databasesortOptionstypeDesc => 'Τύπος (Ω-Α)';

  @override
  String get favoritestitle => 'Αγαπημένα';

  @override
  String get favoritesnoFavorites => 'Δεν υπάρχουν αγαπημένα ακόμη';

  @override
  String get favoritesnoFavoritesDescription => 'Σημειώστε καταχωρίσεις στη βάση δεδομένων ως αγαπημένα για να τα δείτε εδώ.';

  @override
  String get favoritesloginRequired => 'Πρέπει να είστε συνδεδεμένοι για να ορίσετε αγαπημένα.';

  @override
  String get favoritesaddedToFavorites => 'Προστέθηκε στα αγαπημένα';

  @override
  String get favoritesremovedFromFavorites => 'Αφαιρέθηκε από τα αγαπημένα';

  @override
  String get favoritesall => 'Όλα';

  @override
  String get favoritesvictims => 'Θύματα';

  @override
  String get favoritescamps => 'Στρατόπεδα';

  @override
  String get favoritescommanders => 'Διοικητές';

  @override
  String get profiletitle => 'Προφίλ';

  @override
  String get profileaccountSettings => 'Ρυθμίσεις Λογαριασμού';

  @override
  String get profileactions => 'Ενέργειες';

  @override
  String get profileverifyEmail => 'Επαλήθευση email';

  @override
  String get profilechangePassword => 'Αλλαγή κωδικού';

  @override
  String get profileaccountInfo => 'Πληροφορίες λογαριασμού';

  @override
  String get profilelogout => 'Αποσύνδεση';

  @override
  String get profiledeleteAccount => 'Διαγραφή λογαριασμού';

  @override
  String get profileverified => 'Επαληθευμένο';

  @override
  String get profilenotVerified => 'Μη επαληθευμένο';

  @override
  String get profileupdateStatus => 'Ενημέρωση κατάστασης';

  @override
  String get profilelogoutConfirm => 'Θέλετε πραγματικά να αποσυνδεθείτε;';

  @override
  String get profiledeleteConfirm => 'Είστε βέβαιοι ότι θέλετε να διαγράψετε τον λογαριασμό σας; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get admindashboard => 'Πίνακας Ελέγχου Διαχειριστή';

  @override
  String get adminvictims => 'Θύματα';

  @override
  String get admincamps => 'Στρατόπεδα';

  @override
  String get admincommanders => 'Διοικητές';

  @override
  String get adminaddNew => 'Προσθήκη νέου';

  @override
  String get adminedit => 'Επεξεργασία';

  @override
  String get admindelete => 'Διαγραφή';

  @override
  String get adminsave => 'Αποθήκευση';

  @override
  String get admincancel => 'Ακύρωση';

  @override
  String get adminconfirmDelete => 'Θέλετε πραγματικά να διαγράψετε αυτή την καταχώριση; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get timelineeventsoct28_1940 => 'Ιταλική εισβολή στην Ελλάδα';

  @override
  String get timelineeventsapr_1941 => 'Η γερμανική Wehrmacht ξεκινά τη Βαλκανική εκστρατεία';

  @override
  String get timelineeventssummer_1941 => 'Αρχή του Μεγάλου Λιμού';

  @override
  String get timelineeventssep_1941 => 'Σχηματισμός των πρώτων οργανωμένων ομάδων αντίστασης';

  @override
  String get timelineeventsnov_1942 => 'Επιχείρηση Harling: Καταστροφή της γέφυρας Γοργοπόταμου';

  @override
  String get timelineeventsmar24_1943 => 'Σφαγή του Δομένικου (Θεσσαλία)';

  @override
  String get timelineeventsaug17_1943 => 'Καταστροφή της εβραϊκής κοινότητας της Θεσσαλονίκης';

  @override
  String get timelineeventssep14_1943 => 'Ιταλική συνθηκολόγηση';

  @override
  String get timelineeventsoct17_1943 => 'Σφαγή Βιάννου (Κρήτη)';

  @override
  String get timelineeventsjun29_1944 => 'Σφαγή του Διστόμου';

  @override
  String get timelineeventsoct12_1944 => 'Απελευθέρωση των Αθηνών';

  @override
  String get timelineeventsdec28_1944 => 'Δεκεμβριανά: Οδομαχίες στην Αθήνα';

  @override
  String get timelineeventsfeb12_1945 => 'Συμφωνία της Βάρκιζας';

  @override
  String get newstitle => 'Νέα';

  @override
  String get newsathens => 'Αθήνα';

  @override
  String get newsthessaloniki => 'Θεσσαλονίκη';

  @override
  String get newsliberation80Years => '80 Χρόνια Απελευθέρωσης';

  @override
  String get newsjumpToArticle => 'Μετάβαση σε άρθρο';

  @override
  String get newsscrollToTop => 'Στην κορυφή';

  @override
  String get newstoggleArticle => 'Στο άλλο άρθρο';

  @override
  String get commonloading => 'Φόρτωση...';

  @override
  String get commonerror => 'Σφάλμα';

  @override
  String get commonsuccess => 'Επιτυχία';

  @override
  String get commonconfirm => 'Επιβεβαίωση';

  @override
  String get commoncancel => 'Ακύρωση';

  @override
  String get commonsave => 'Αποθήκευση';

  @override
  String get commondelete => 'Διαγραφή';

  @override
  String get commonedit => 'Επεξεργασία';

  @override
  String get commonadd => 'Προσθήκη';

  @override
  String get commonsearch => 'Αναζήτηση';

  @override
  String get commonfilter => 'Φίλτρο';

  @override
  String get commonsort => 'Ταξινόμηση';

  @override
  String get commonclose => 'Κλείσιμο';

  @override
  String get commonback => 'Πίσω';

  @override
  String get commonnext => 'Επόμενο';

  @override
  String get commonprevious => 'Προηγούμενο';

  @override
  String get commonyes => 'Ναι';

  @override
  String get commonno => 'Όχι';

  @override
  String get commonok => 'Εντάξει';

  @override
  String get commonunknown => 'Άγνωστο';

  @override
  String get commonoptional => 'Προαιρετικό';

  @override
  String get commonrequired => 'Απαιτείται';

  @override
  String get commonhideSearch => 'Απόκρυψη αναζήτησης';

  @override
  String get commonshowSearch => 'Εμφάνιση αναζήτησης';

  @override
  String get commonnoImage => 'Δεν υπάρχει διαθέσιμη εικόνα';

  @override
  String get commonimageLoadError => 'Η εικόνα δεν μπόρεσε να φορτωθεί';

  @override
  String get validationrequired => 'Αυτό το πεδίο είναι απαραίτητο';

  @override
  String get validationinvalidEmail => 'Παρακαλώ εισάγετε μια έγκυρη διεύθυνση email';

  @override
  String get validationpasswordTooShort => 'Ο κωδικός πρόσβασης πρέπει να είναι τουλάχιστον 8 χαρακτήρες';

  @override
  String get validationpasswordsDoNotMatch => 'Οι κωδικοί πρόσβασης δεν ταιριάζουν';

  @override
  String get validationusernameTooShort => 'Το όνομα χρήστη πρέπει να είναι μεταξύ 4 και 10 χαρακτήρων';

  @override
  String get drawerhome => 'Αρχική';

  @override
  String get drawerdatabase => 'Βάση Δεδομένων';

  @override
  String get drawernews => 'Νέα';

  @override
  String get drawertimeline => 'Χρονολόγιο';

  @override
  String get drawermap => 'Χάρτης';

  @override
  String get drawerfavorites => 'Αγαπημένα';

  @override
  String get drawerprofile => 'Προφίλ';

  @override
  String get draweradminDashboard => 'Πίνακας Ελέγχου Διαχειριστή';

  @override
  String get draweradministrator => 'ΔΙΑΧΕΙΡΙΣΤΗΣ';

  @override
  String get draweradminPermissionActive => 'Άδεια διαχειριστή ενεργή';

  @override
  String get drawerfullAccess => 'Πλήρης πρόσβαση σε όλες τις διαχειριστικές λειτουργίες';

  @override
  String get drawernotLoggedIn => 'Δεν είστε συνδεδεμένοι';

  @override
  String get drawerloginForMoreFeatures => 'Συνδεθείτε για περισσότερες λειτουργίες';

  @override
  String get loadingNavigation => 'Φόρτωση πλοήγησης...';

  @override
  String get loadingDatabase => 'Η βάση δεδομένων επαναφορτώνεται...';

  @override
  String get errorRetryButton => 'Προσπαθήστε ξανά';

  @override
  String errorLoadingNavigation(String error) {
    return 'Σφάλμα φόρτωσης πλοήγησης: $error';
  }

  @override
  String get errorDatabaseLoginRequired => 'Πρέπει να συνδεθείτε για να αποκτήσετε πρόσβαση στη βάση δεδομένων.';

  @override
  String get errorAdminLoginRequired => 'Πρέπει να συνδεθείτε για να αποκτήσετε πρόσβαση στον πίνακα ελέγχου διαχειριστή.';

  @override
  String get errorAdminPermissionRequired => 'Δεν έχετε άδεια διαχειριστή για αυτή τη λειτουργία.';

  @override
  String get errorRepositoryUnavailable => 'Το αποθετήριο δεν είναι διαθέσιμο. Επαναφορτώστε την εφαρμογή.';

  @override
  String get userEmail => 'Email χρήστη';

  @override
  String get unknownEmail => 'Άγνωστο email';

  @override
  String get adminBadge => 'ΔΙΑΧΕΙΡΙΣΤΗΣ';

  @override
  String get adminPermissionActiveShort => 'Διαχειριστής ενεργός';

  @override
  String get languageSwitch => 'Γλώσσα';

  @override
  String get languageSwitchSubtitle => 'Αλλαγή γλώσσας εφαρμογής';

  @override
  String get languageDialogTitle => 'Επιλέξτε γλώσσα';

  @override
  String get languageDialogClose => 'Κλείσιμο';

  @override
  String get desktopUserInfo => 'Πληροφορίες Χρήστη';

  @override
  String get mobileDrawerTitle => 'Γρήγορη Πρόσβαση';

  @override
  String get tabletLayoutTitle => 'Προβολή Tablet';

  @override
  String get accessibilityNavigationHome => 'Πλοήγηση στην αρχική';

  @override
  String get accessibilityNavigationTimeline => 'Πλοήγηση στο χρονολόγιο';

  @override
  String get accessibilityNavigationMap => 'Πλοήγηση στον χάρτη';

  @override
  String get accessibilityNavigationFavorites => 'Πλοήγηση στα αγαπημένα';

  @override
  String get accessibilityNavigationProfile => 'Πλοήγηση στο προφίλ';

  @override
  String get accessibilityLanguageSwitch => 'Αλλαγή γλώσσας';

  @override
  String get accessibilityAdminPanel => 'Πρόσβαση πίνακα διαχειριστή';

  @override
  String get navigationRailExtend => 'Επέκταση πλοήγησης';

  @override
  String get navigationRailCollapse => 'Σύμπτυξη πλοήγησης';

  @override
  String get quickAccessTitle => 'Γρήγορη Πρόσβαση';

  @override
  String get adminStatsTitle => 'Στατιστικά Διαχειριστή';

  @override
  String get verificationStatus => 'Κατάσταση Επαλήθευσης';

  @override
  String get adminDashboardTooltip => 'Άνοιγμα πίνακα διαχειριστή';
}

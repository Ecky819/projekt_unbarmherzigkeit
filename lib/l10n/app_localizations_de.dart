// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => '#PROJEKT UNBARMHERZIGKEIT';

  @override
  String get navigationhome => 'Startseite';

  @override
  String get navigationtimeline => 'Zeitlinie';

  @override
  String get navigationmap => 'Karte';

  @override
  String get navigationfavorites => 'Favoriten';

  @override
  String get navigationprofile => 'Profil';

  @override
  String get navigationdatabase => 'Datenbank';

  @override
  String get navigationnews => 'Nachrichten';

  @override
  String get navigationlogin => 'Anmelden';

  @override
  String get homenewsCard1Title => '80 Jahre Befreiung von Athen';

  @override
  String get homenewsCard2Title => '80 Jahre Befreiung von Thessaloniki';

  @override
  String get hometimelineTitle => 'ZEITLINIE';

  @override
  String get hometimelineDescription => 'Hier finden Sie alle historischen Ereignisse in Griechenland von 1941 bis 1945.';

  @override
  String get homemapTitle => 'KARTE';

  @override
  String get homemapDescription => 'Hier finden Sie unsere Karte mit allen markierten Lagerstandorten.';

  @override
  String get mapsearchHint => 'Suche';

    @override
  String get mapLegend => 'Legende';

    @override
  String get mapMainCamp => 'Hauptlager';

    @override
  String get mapAuxCamp => 'Außenlager';

    @override
  String get mapReminder => 'Mahnmal';

  @override
  String get authwelcomeBack => 'Willkommen zurück';

  @override
  String get authloginSubtitle => 'Anmelden um fortzufahren';

  @override
  String get authemail => 'E-Mail-Adresse';

  @override
  String get authpassword => 'Passwort';

  @override
  String get authlogin => 'Anmelden';

  @override
  String get authregister => 'Registrieren';

  @override
  String get authforgotPassword => 'Passwort vergessen?';

  @override
  String get authnoAccount => 'Noch kein Konto?';

  @override
  String get authregisterNow => 'Jetzt registrieren';

  @override
  String get authcreateAccount => 'Neues Konto erstellen';

  @override
  String get authfillAllFields => 'Alle Felder ausfüllen zur Registrierung';

  @override
  String get authusername => 'Benutzername';

  @override
  String get authconfirmPassword => 'Passwort bestätigen';

  @override
  String get authalreadyHaveAccount => 'Bereits ein Konto?';

  @override
  String get authloginNow => 'Jetzt anmelden';

  @override
  String get authsignInWithGoogle => 'Mit Google anmelden';

  @override
  String get authsignInWithApple => 'Mit Apple anmelden';

  @override
  String get authsignInWithFacebook => 'Mit Facebook anmelden';

  @override
  String get author => 'oder';

  @override
  String get databasetitle => 'Datenbank';

  @override
  String get databasesearch => 'Suchen';

  @override
  String get databasereset => 'Zurücksetzen';

  @override
  String get databasename => 'Name';

  @override
  String get databaseplace => 'Ort';

  @override
  String get databaseyear => 'Jahr';

  @override
  String get databaseevent => 'Ereignis/Typ';

  @override
  String get databasenameHint => 'Name von Opfern, Kommandanten oder Lagern';

  @override
  String get databaseplaceHint => 'Lagerstandort, Geburts-/Sterbeort';

  @override
  String get databaseyearHint => 'Geburts-/Sterbe-/Eröffnungs-/Befreiungsjahr';

  @override
  String get databaseeventHint => 'Lagertyp, Schicksal, Beruf, Religion';

  @override
  String databaseresults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ergebnisse',
      one: 'Ergebnis',
    );
    return '$count $_temp0 gefunden';
  }

  @override
  String get databasenoresults => 'Suchbegriffe eingeben und \'Suchen\' drücken';

  @override
  String databasesortBy(String option) {
    return 'Sortieren nach: $option';
  }

  @override
  String get databasesortOptionsnameAsc => 'Name (A-Z)';

  @override
  String get databasesortOptionsnameDesc => 'Name (Z-A)';

  @override
  String get databasesortOptionsdateAsc => 'Datum (alt-neu)';

  @override
  String get databasesortOptionsdateDesc => 'Datum (neu-alt)';

  @override
  String get databasesortOptionstypeAsc => 'Typ (A-Z)';

  @override
  String get databasesortOptionstypeDesc => 'Typ (Z-A)';

  @override
  String get favoritestitle => 'Favoriten';

  @override
  String get favoritesnoFavorites => 'Noch keine Favoriten';

  @override
  String get favoritesnoFavoritesDescription => 'Markieren Sie Einträge in der Datenbank als Favoriten, um sie hier zu sehen.';

  @override
  String get favoritesloginRequired => 'Sie müssen angemeldet sein, um Favoriten festzulegen.';

  @override
  String get favoritesaddedToFavorites => 'Zu Favoriten hinzugefügt';

  @override
  String get favoritesremovedFromFavorites => 'Von Favoriten entfernt';

  @override
  String get favoritesall => 'Alle';

  @override
  String get favoritesvictims => 'Opfer';

  @override
  String get favoritescamps => 'Lager';

  @override
  String get favoritescommanders => 'Kommandanten';

  @override
  String get profiletitle => 'Profil';

  @override
  String get profileaccountSettings => 'Kontoeinstellungen';

  @override
  String get profileactions => 'Aktionen';

  @override
  String get profileverifyEmail => 'E-Mail verifizieren';

  @override
  String get profilechangePassword => 'Passwort ändern';

  @override
  String get profileaccountInfo => 'Kontoinformationen';

  @override
  String get profilelogout => 'Abmelden';

  @override
  String get profiledeleteAccount => 'Konto löschen';

  @override
  String get profileverified => 'Verifiziert';

  @override
  String get profilenotVerified => 'Nicht verifiziert';

  @override
  String get profileupdateStatus => 'Status aktualisieren';

  @override
  String get profilelogoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get profiledeleteConfirm => 'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get admindashboard => 'Admin-Dashboard';

  @override
  String get adminvictims => 'Opfer';

  @override
  String get admincamps => 'Lager';

  @override
  String get admincommanders => 'Kommandanten';

  @override
  String get adminaddNew => 'Neu hinzufügen';

  @override
  String get adminedit => 'Bearbeiten';

  @override
  String get admindelete => 'Löschen';

  @override
  String get adminsave => 'Speichern';

  @override
  String get admincancel => 'Abbrechen';

  @override
  String get adminconfirmDelete => 'Möchten Sie diesen Eintrag wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get timelineeventsoct28_1940 => 'Italienische Invasion Griechenlands';

  @override
  String get timelineeventsapr_1941 => 'Deutsche Wehrmacht startet Balkankampagne';

  @override
  String get timelineeventssummer_1941 => 'Beginn der großen Hungersnot';

  @override
  String get timelineeventssep_1941 => 'Bildung der ersten organisierten Widerstandsgruppen';

  @override
  String get timelineeventsnov_1942 => 'Operation Harling: Zerstörung der Gorgopotamos-Brücke';

  @override
  String get timelineeventsmar24_1943 => 'Domeniko-Massaker (Thessalien)';

  @override
  String get timelineeventsaug17_1943 => 'Zerstörung der jüdischen Gemeinde von Thessaloniki';

  @override
  String get timelineeventssep14_1943 => 'Italienische Kapitulation';

  @override
  String get timelineeventsoct17_1943 => 'Viannos-Massaker (Kreta)';

  @override
  String get timelineeventsjun29_1944 => 'Distomo-Massaker';

  @override
  String get timelineeventsoct12_1944 => 'Befreiung von Athen';

  @override
  String get timelineeventsdec28_1944 => 'Dekemvriana: Straßenkämpfe in Athen';

  @override
  String get timelineeventsfeb12_1945 => 'Varkiza-Abkommen';

  @override
  String get newstitle => 'Nachrichten';

  @override
  String get newsathens => 'Athen';

  @override
  String get newsthessaloniki => 'Thessaloniki';

  @override
  String get newsliberation80Years => '80 Jahre Befreiung';

  @override
  String get newsjumpToArticle => 'Zu Artikel springen';

  @override
  String get newsscrollToTop => 'Nach oben';

  @override
  String get newstoggleArticle => 'Zu anderem Artikel';

  @override
  String get commonloading => 'Wird geladen...';

  @override
  String get commonerror => 'Fehler';

  @override
  String get commonsuccess => 'Erfolgreich';

  @override
  String get commonconfirm => 'Bestätigen';

  @override
  String get commoncancel => 'Abbrechen';

  @override
  String get commonsave => 'Speichern';

  @override
  String get commondelete => 'Löschen';

  @override
  String get commonedit => 'Bearbeiten';

  @override
  String get commonadd => 'Hinzufügen';

  @override
  String get commonsearch => 'Suchen';

  @override
  String get commonfilter => 'Filter';

  @override
  String get commonsort => 'Sortieren';

  @override
  String get commonclose => 'Schließen';

  @override
  String get commonback => 'Zurück';

  @override
  String get commonnext => 'Weiter';

  @override
  String get commonprevious => 'Vorherige';

  @override
  String get commonyes => 'Ja';

  @override
  String get commonno => 'Nein';

  @override
  String get commonok => 'OK';

  @override
  String get commonunknown => 'Unbekannt';

  @override
  String get commonoptional => 'Optional';

  @override
  String get commonrequired => 'Erforderlich';

  @override
  String get commonhideSearch => 'Suche ausblenden';

  @override
  String get commonshowSearch => 'Suche anzeigen';

  @override
  String get commonnoImage => 'Kein Bild verfügbar';

  @override
  String get commonimageLoadError => 'Bild konnte nicht geladen werden';

  @override
  String get validationrequired => 'Dieses Feld ist erforderlich';

  @override
  String get validationinvalidEmail => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get validationpasswordTooShort => 'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get validationpasswordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get validationusernameTooShort => 'Benutzername muss zwischen 4 und 10 Zeichen lang sein';

  @override
  String get drawerhome => 'Startseite';

  @override
  String get drawerdatabase => 'Datenbank';

  @override
  String get drawernews => 'Nachrichten';

  @override
  String get drawertimeline => 'Zeitlinie';

  @override
  String get drawermap => 'Karte';

  @override
  String get drawerfavorites => 'Favoriten';

  @override
  String get drawerprofile => 'Profil';

  @override
  String get draweradminDashboard => 'Admin-Dashboard';

  @override
  String get draweradministrator => 'ADMINISTRATOR';

  @override
  String get draweradminPermissionActive => 'Admin-Berechtigung aktiv';

  @override
  String get drawerfullAccess => 'Vollzugriff auf alle Verwaltungsfunktionen';

  @override
  String get drawernotLoggedIn => 'Nicht angemeldet';

  @override
  String get drawerloginForMoreFeatures => 'Anmelden für weitere Funktionen';

  @override
  String get loadingNavigation => 'Lade Navigation...';

  @override
  String get loadingDatabase => 'Datenbank wird neu geladen...';

  @override
  String get errorRetryButton => 'Erneut versuchen';

  @override
  String errorLoadingNavigation(String error) {
    return 'Fehler beim Laden der Navigation: $error';
  }

  @override
  String get errorDatabaseLoginRequired => 'Sie müssen sich anmelden, um auf die Datenbank zugreifen zu können.';

  @override
  String get errorAdminLoginRequired => 'Sie müssen sich anmelden, um auf das Admin-Dashboard zugreifen zu können.';

  @override
  String get errorAdminPermissionRequired => 'Sie haben keine Admin-Berechtigung für diese Funktion.';

  @override
  String get errorRepositoryUnavailable => 'Repository nicht verfügbar. Laden Sie die App neu.';

  @override
  String get userEmail => 'Benutzer E-Mail';

  @override
  String get unknownEmail => 'Unbekannte E-Mail';

  @override
  String get adminBadge => 'ADMIN';

  @override
  String get adminPermissionActiveShort => 'Admin aktiv';

  @override
  String get languageSwitch => 'Sprache';

  @override
  String get languageSwitchSubtitle => 'App-Sprache ändern';

  @override
  String get languageDialogTitle => 'Sprache wählen';

  @override
  String get languageDialogClose => 'Schließen';

  @override
  String get desktopUserInfo => 'Benutzerinformationen';

  @override
  String get mobileDrawerTitle => 'Schnellzugriff';

  @override
  String get tabletLayoutTitle => 'Tablet-Ansicht';

  @override
  String get accessibilityNavigationHome => 'Zur Startseite navigieren';

  @override
  String get accessibilityNavigationTimeline => 'Zur Zeitlinie navigieren';

  @override
  String get accessibilityNavigationMap => 'Zur Karte navigieren';

  @override
  String get accessibilityNavigationFavorites => 'Zu Favoriten navigieren';

  @override
  String get accessibilityNavigationProfile => 'Zum Profil navigieren';

  @override
  String get accessibilityLanguageSwitch => 'Sprache wechseln';

  @override
  String get accessibilityAdminPanel => 'Admin-Panel öffnen';

  @override
  String get navigationRailExtend => 'Navigation erweitern';

  @override
  String get navigationRailCollapse => 'Navigation einklappen';

  @override
  String get quickAccessTitle => 'Schnellzugriff';

  @override
  String get adminStatsTitle => 'Admin-Statistiken';

  @override
  String get verificationStatus => 'Verifizierungsstatus';

  @override
  String get adminDashboardTooltip => 'Admin-Dashboard öffnen';
}

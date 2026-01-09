// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nautical School';

  @override
  String get activitiesTitle => 'Water sports activities';

  @override
  String get reserve => 'Book';

  @override
  String get chooseSchedule => 'Choose a time slot';

  @override
  String get morning => 'Morning (9:00 - 13:00)';

  @override
  String get afternoon => 'Afternoon (16:00 - 20:00)';

  @override
  String get cancel => 'Cancel';

  @override
  String get accept => 'Accept';

  @override
  String get confirmedTitle => 'Booking confirmed!';

  @override
  String get confirmedText => 'You have successfully booked the time slot:';

  @override
  String get ok => 'OK';

  @override
  String get price => 'Price';

  @override
  String get duration => 'Duration';

  @override
  String get level => 'Level';

  @override
  String get rating => 'Rating';

  @override
  String get loading => 'Loading...';
}

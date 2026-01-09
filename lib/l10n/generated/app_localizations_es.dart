// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'GandiaSurf';

  @override
  String get activitiesTitle => 'Listado de actividades náuticas';

  @override
  String get reserve => 'Reservar';

  @override
  String get chooseSchedule => 'Elige un horario';

  @override
  String get morning => 'Mañana (9:00 - 13:00)';

  @override
  String get afternoon => 'Tarde (16:00 - 20:00)';

  @override
  String get cancel => 'Cancelar';

  @override
  String get accept => 'Aceptar';

  @override
  String get confirmedTitle => '¡Inscripción confirmada!';

  @override
  String get confirmedText => 'Te has inscrito correctamente en el horario:';

  @override
  String get ok => 'OK';

  @override
  String get price => 'Precio';

  @override
  String get duration => 'Duración';

  @override
  String get level => 'Nivel';

  @override
  String get rating => 'Valoración';

  @override
  String get loading => 'Cargando...';
}

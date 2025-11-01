// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get language => 'Español';

  @override
  String get home => 'Inicio';

  @override
  String get songbooks => 'Cancioneros';

  @override
  String get churches => 'Iglesias';

  @override
  String get settings => 'Configuración';

  @override
  String get display => 'Pantalla';

  @override
  String get textSize => 'Tamaño de Texto';

  @override
  String get adjustLyricsTextSize =>
      'Ajustar el tamaño del texto de las letras';

  @override
  String get theme => 'Tema';

  @override
  String get chooseAppAppearance => 'Elegir apariencia de la aplicación';

  @override
  String get keepScreenOn => 'Mantener Pantalla Encendida';

  @override
  String get preventScreenFromSleeping => 'Evitar que la pantalla se apague';

  @override
  String get small => 'Pequeño';

  @override
  String get medium => 'Mediano';

  @override
  String get large => 'Grande';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get musicAndAudio => 'Música y Audio';

  @override
  String get defaultTranspose => 'Transposición Predeterminada';

  @override
  String get automaticKeyAdjustment => 'Ajuste Automático de Tonalidad';

  @override
  String get showChordsByDefault => 'Mostrar Acordes por Defecto';

  @override
  String get displayChordsWhenOpeningSongs =>
      'Mostrar acordes al abrir canciones';

  @override
  String get aboutAndSupport => 'Acerca de y Soporte';

  @override
  String get about => 'Acerca de';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get announcements => 'Anuncios';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get searchHymnsSongsOrNumbers =>
      'Buscar himnos, canciones o números...';

  @override
  String get explore => 'Explorar';

  @override
  String get browse => 'Navegar';

  @override
  String get categories => 'Categorías';

  @override
  String get manage => 'Administrar';

  @override
  String get recent => 'Reciente';

  @override
  String get lastPlayed => 'Últimas reproducidas';

  @override
  String get favorites => 'Favoritos';

  @override
  String songsCount(int count) {
    return '$count canciones';
  }

  @override
  String get recentlyPlayed => 'Reproducidas Recientemente';

  @override
  String get viewAll => 'Ver Todas';

  @override
  String get popularThisWeek => 'Popular Esta Semana';

  @override
  String get hymn => 'Himno';

  @override
  String playsCount(int count) {
    return '$count reproducciones';
  }

  @override
  String get searchAvailableSongbooks => 'Buscar cancioneros disponibles';

  @override
  String get installed => 'Instalados';

  @override
  String get available => 'Disponibles';

  @override
  String installedCount(int count) {
    return 'Instalados ($count)';
  }

  @override
  String availableCount(int count) {
    return 'Disponibles ($count)';
  }

  @override
  String get installedSingular => 'Instalado';

  @override
  String get availableSingular => 'Disponible';

  @override
  String get update => 'Actualizar';

  @override
  String get delete => 'Eliminar';

  @override
  String get download => 'Descargar';

  @override
  String hymnsCount(int count) {
    return '$count himnos';
  }

  @override
  String lastUpdated(String date) {
    return 'Última actualización: $date';
  }

  @override
  String get browseCategories => 'Explorar Categorías';

  @override
  String get exploreCategoriesDescription =>
      'Explora himnos organizados por temas y ocasiones';

  @override
  String get searchCategories => 'Buscar categorías';

  @override
  String get searchSongs => 'Buscar canciones';

  @override
  String get backToSongbooks => 'Volver a Cancioneros';

  @override
  String get backToCategories => 'Volver a Categorías';

  @override
  String downloadedSuccessfully(String title) {
    return '¡$title descargado exitosamente!';
  }

  @override
  String updatedSuccessfully(String title) {
    return '¡$title actualizado exitosamente!';
  }

  @override
  String deletedSuccessfully(String title) {
    return '¡$title eliminado exitosamente!';
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'CRM WhatsApp'**
  String get appTitle;

  /// No description provided for @pipeline.
  ///
  /// In es, this message translates to:
  /// **'Pipeline'**
  String get pipeline;

  /// No description provided for @tasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas'**
  String get tasks;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @pipelineTitle.
  ///
  /// In es, this message translates to:
  /// **'Pipeline 🎯'**
  String get pipelineTitle;

  /// No description provided for @tasksTitle.
  ///
  /// In es, this message translates to:
  /// **'Tareas 📋'**
  String get tasksTitle;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil 👤'**
  String get profileTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In es, this message translates to:
  /// **'¡Hola de nuevo! 👋'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciá sesión y cerrá más ventas'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get loginButton;

  /// No description provided for @loginNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tenés cuenta? '**
  String get loginNoAccount;

  /// No description provided for @loginRegisterLink.
  ///
  /// In es, this message translates to:
  /// **'Registrate'**
  String get loginRegisterLink;

  /// No description provided for @registerWelcome.
  ///
  /// In es, this message translates to:
  /// **'¡Empezá ahora! 🚀'**
  String get registerWelcome;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Creá tu cuenta y organizá tus ventas'**
  String get registerSubtitle;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get registerButton;

  /// No description provided for @registerHasAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tenés cuenta? '**
  String get registerHasAccount;

  /// No description provided for @registerLoginLink.
  ///
  /// In es, this message translates to:
  /// **'Iniciá sesión'**
  String get registerLoginLink;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Cuenta creada! Revisá tu email para confirmar.'**
  String get registerSuccess;

  /// No description provided for @email.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// No description provided for @passwordMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// No description provided for @name.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In es, this message translates to:
  /// **'+5491112345678'**
  String get phoneHint;

  /// No description provided for @phoneWithCountry.
  ///
  /// In es, this message translates to:
  /// **'Teléfono (con código de país)'**
  String get phoneWithCountry;

  /// No description provided for @company.
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get company;

  /// No description provided for @source.
  ///
  /// In es, this message translates to:
  /// **'Origen'**
  String get source;

  /// No description provided for @sourceHint.
  ///
  /// In es, this message translates to:
  /// **'Ej: Instagram, referido, web'**
  String get sourceHint;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @undo.
  ///
  /// In es, this message translates to:
  /// **'Deshacer'**
  String get undo;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @newClient.
  ///
  /// In es, this message translates to:
  /// **'Nuevo cliente'**
  String get newClient;

  /// No description provided for @createClient.
  ///
  /// In es, this message translates to:
  /// **'Crear cliente'**
  String get createClient;

  /// No description provided for @nameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre es requerido'**
  String get nameRequired;

  /// No description provided for @required.
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get required;

  /// No description provided for @clientUpdated.
  ///
  /// In es, this message translates to:
  /// **'✅ Cliente actualizado'**
  String get clientUpdated;

  /// No description provided for @clientDeleted.
  ///
  /// In es, this message translates to:
  /// **'Cliente eliminado'**
  String get clientDeleted;

  /// No description provided for @deleteClient.
  ///
  /// In es, this message translates to:
  /// **'Eliminar cliente'**
  String get deleteClient;

  /// No description provided for @deleteClientConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que querés eliminar a \"{name}\"? Esta acción se puede deshacer.'**
  String deleteClientConfirm(String name);

  /// No description provided for @moveClientTo.
  ///
  /// In es, this message translates to:
  /// **'Mover \"{name}\" a:'**
  String moveClientTo(String name);

  /// No description provided for @noClients.
  ///
  /// In es, this message translates to:
  /// **'Sin clientes'**
  String get noClients;

  /// No description provided for @noPhoneNumber.
  ///
  /// In es, this message translates to:
  /// **'Este cliente no tiene teléfono'**
  String get noPhoneNumber;

  /// No description provided for @newNote.
  ///
  /// In es, this message translates to:
  /// **'Nueva nota'**
  String get newNote;

  /// No description provided for @editNote.
  ///
  /// In es, this message translates to:
  /// **'Editar nota'**
  String get editNote;

  /// No description provided for @noteHint.
  ///
  /// In es, this message translates to:
  /// **'Escribí tu nota...'**
  String get noteHint;

  /// No description provided for @saveNote.
  ///
  /// In es, this message translates to:
  /// **'Guardar nota'**
  String get saveNote;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar cambios'**
  String get saveChanges;

  /// No description provided for @noNotes.
  ///
  /// In es, this message translates to:
  /// **'Sin notas aún'**
  String get noNotes;

  /// No description provided for @noNotesHint.
  ///
  /// In es, this message translates to:
  /// **'Agregá una con el botón +'**
  String get noNotesHint;

  /// No description provided for @noteDeleted.
  ///
  /// In es, this message translates to:
  /// **'Nota eliminada'**
  String get noteDeleted;

  /// No description provided for @newTask.
  ///
  /// In es, this message translates to:
  /// **'Nueva tarea'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In es, this message translates to:
  /// **'Editar tarea'**
  String get editTask;

  /// No description provided for @taskTitle.
  ///
  /// In es, this message translates to:
  /// **'Título de la tarea'**
  String get taskTitle;

  /// No description provided for @taskDueDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de vencimiento (opcional)'**
  String get taskDueDate;

  /// No description provided for @createTask.
  ///
  /// In es, this message translates to:
  /// **'Crear tarea'**
  String get createTask;

  /// No description provided for @noTasks.
  ///
  /// In es, this message translates to:
  /// **'Sin tareas pendientes'**
  String get noTasks;

  /// No description provided for @noTasksHint.
  ///
  /// In es, this message translates to:
  /// **'Creá una con el botón +'**
  String get noTasksHint;

  /// No description provided for @taskDeleted.
  ///
  /// In es, this message translates to:
  /// **'Tarea eliminada'**
  String get taskDeleted;

  /// No description provided for @dueDate.
  ///
  /// In es, this message translates to:
  /// **'Vence: {date}'**
  String dueDate(String date);

  /// No description provided for @complete.
  ///
  /// In es, this message translates to:
  /// **'Completar'**
  String get complete;

  /// No description provided for @allCaughtUp.
  ///
  /// In es, this message translates to:
  /// **'¡Todo al día!'**
  String get allCaughtUp;

  /// No description provided for @noPendingTasks.
  ///
  /// In es, this message translates to:
  /// **'No hay tareas pendientes'**
  String get noPendingTasks;

  /// No description provided for @info.
  ///
  /// In es, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @notes.
  ///
  /// In es, this message translates to:
  /// **'Notas'**
  String get notes;

  /// No description provided for @whatsapp.
  ///
  /// In es, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @somethingWentWrong.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal'**
  String get somethingWentWrong;

  /// No description provided for @searchClients.
  ///
  /// In es, this message translates to:
  /// **'Buscar clientes...'**
  String get searchClients;

  /// No description provided for @typeToSearch.
  ///
  /// In es, this message translates to:
  /// **'Escribí para buscar'**
  String get typeToSearch;

  /// No description provided for @noResults.
  ///
  /// In es, this message translates to:
  /// **'Sin resultados'**
  String get noResults;

  /// No description provided for @sortRecent.
  ///
  /// In es, this message translates to:
  /// **'Más recientes'**
  String get sortRecent;

  /// No description provided for @sortName.
  ///
  /// In es, this message translates to:
  /// **'Nombre A-Z'**
  String get sortName;

  /// No description provided for @sortOldest.
  ///
  /// In es, this message translates to:
  /// **'Más antiguos'**
  String get sortOldest;

  /// No description provided for @sort.
  ///
  /// In es, this message translates to:
  /// **'Ordenar'**
  String get sort;

  /// No description provided for @theme.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeAuto.
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get themeAuto;

  /// No description provided for @noEmail.
  ///
  /// In es, this message translates to:
  /// **'Sin email'**
  String get noEmail;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro?'**
  String get logoutConfirm;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @created.
  ///
  /// In es, this message translates to:
  /// **'Creado'**
  String get created;

  /// No description provided for @updated.
  ///
  /// In es, this message translates to:
  /// **'Actualizado'**
  String get updated;

  /// No description provided for @statusNew.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get statusNew;

  /// No description provided for @statusContacted.
  ///
  /// In es, this message translates to:
  /// **'Contactado'**
  String get statusContacted;

  /// No description provided for @statusInterested.
  ///
  /// In es, this message translates to:
  /// **'Interesado'**
  String get statusInterested;

  /// No description provided for @statusNegotiating.
  ///
  /// In es, this message translates to:
  /// **'Negociando'**
  String get statusNegotiating;

  /// No description provided for @statusClosedWon.
  ///
  /// In es, this message translates to:
  /// **'Ganado'**
  String get statusClosedWon;

  /// No description provided for @statusClosedLost.
  ///
  /// In es, this message translates to:
  /// **'Perdido'**
  String get statusClosedLost;

  /// No description provided for @newLabel.
  ///
  /// In es, this message translates to:
  /// **'Nuevo'**
  String get newLabel;

  /// No description provided for @filters.
  ///
  /// In es, this message translates to:
  /// **'Filtros'**
  String get filters;

  /// No description provided for @clearFilters.
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get clearFilters;

  /// No description provided for @filterByDate.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por fecha'**
  String get filterByDate;

  /// No description provided for @filterBySource.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por origen'**
  String get filterBySource;

  /// No description provided for @dateRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de fechas'**
  String get dateRange;

  /// No description provided for @from.
  ///
  /// In es, this message translates to:
  /// **'Desde'**
  String get from;

  /// No description provided for @to.
  ///
  /// In es, this message translates to:
  /// **'Hasta'**
  String get to;

  /// No description provided for @allSources.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get allSources;

  /// No description provided for @apply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get apply;

  /// No description provided for @activeFilters.
  ///
  /// In es, this message translates to:
  /// **'{count} filtro(s) activo(s)'**
  String activeFilters(int count);

  /// No description provided for @metrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get metrics;

  /// No description provided for @conversionRate.
  ///
  /// In es, this message translates to:
  /// **'Tasa de conversión'**
  String get conversionRate;

  /// No description provided for @newThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Nuevos esta semana'**
  String get newThisWeek;

  /// No description provided for @newThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Nuevos este mes'**
  String get newThisMonth;

  /// No description provided for @overdueTasks.
  ///
  /// In es, this message translates to:
  /// **'Tareas vencidas'**
  String get overdueTasks;

  /// No description provided for @totalClients.
  ///
  /// In es, this message translates to:
  /// **'Total clientes'**
  String get totalClients;

  /// No description provided for @byStatus.
  ///
  /// In es, this message translates to:
  /// **'Por estado'**
  String get byStatus;

  /// No description provided for @followUpReminder.
  ///
  /// In es, this message translates to:
  /// **'Recordatorio de seguimiento'**
  String get followUpReminder;

  /// No description provided for @setFollowUp.
  ///
  /// In es, this message translates to:
  /// **'Programar seguimiento'**
  String get setFollowUp;

  /// No description provided for @followUpDate.
  ///
  /// In es, this message translates to:
  /// **'Fecha de seguimiento'**
  String get followUpDate;

  /// No description provided for @followUpDue.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento vencido'**
  String get followUpDue;

  /// No description provided for @followUpScheduled.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento programado'**
  String get followUpScheduled;

  /// No description provided for @removeFollowUp.
  ///
  /// In es, this message translates to:
  /// **'Quitar recordatorio'**
  String get removeFollowUp;

  /// No description provided for @followUpUpdated.
  ///
  /// In es, this message translates to:
  /// **'Seguimiento actualizado'**
  String get followUpUpdated;

  /// No description provided for @dealValue.
  ///
  /// In es, this message translates to:
  /// **'Monto de venta'**
  String get dealValue;

  /// No description provided for @currency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get currency;

  /// No description provided for @totalRevenue.
  ///
  /// In es, this message translates to:
  /// **'Revenue total'**
  String get totalRevenue;

  /// No description provided for @revenueThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Revenue este mes'**
  String get revenueThisMonth;

  /// No description provided for @revenueWon.
  ///
  /// In es, this message translates to:
  /// **'Revenue ganado'**
  String get revenueWon;

  /// No description provided for @revenueByStatus.
  ///
  /// In es, this message translates to:
  /// **'Revenue por estado'**
  String get revenueByStatus;

  /// No description provided for @metricsTitle.
  ///
  /// In es, this message translates to:
  /// **'Métricas 📊'**
  String get metricsTitle;

  /// No description provided for @exportCsv.
  ///
  /// In es, this message translates to:
  /// **'Exportar datos (CSV)'**
  String get exportCsv;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;
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
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

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
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

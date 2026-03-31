// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CRM WhatsApp';

  @override
  String get pipeline => 'Pipeline';

  @override
  String get tasks => 'Tareas';

  @override
  String get profile => 'Perfil';

  @override
  String get pipelineTitle => 'Pipeline 🎯';

  @override
  String get tasksTitle => 'Tareas 📋';

  @override
  String get profileTitle => 'Perfil 👤';

  @override
  String get loginWelcome => '¡Hola de nuevo! 👋';

  @override
  String get loginSubtitle => 'Iniciá sesión y cerrá más ventas';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginNoAccount => '¿No tenés cuenta? ';

  @override
  String get loginRegisterLink => 'Registrate';

  @override
  String get registerWelcome => '¡Empezá ahora! 🚀';

  @override
  String get registerSubtitle => 'Creá tu cuenta y organizá tus ventas';

  @override
  String get registerButton => 'Crear cuenta';

  @override
  String get registerHasAccount => '¿Ya tenés cuenta? ';

  @override
  String get registerLoginLink => 'Iniciá sesión';

  @override
  String get registerSuccess =>
      '¡Cuenta creada! Revisá tu email para confirmar.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Email inválido';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get name => 'Nombre';

  @override
  String get phone => 'Teléfono';

  @override
  String get phoneHint => '+5491112345678';

  @override
  String get phoneWithCountry => 'Teléfono (con código de país)';

  @override
  String get company => 'Empresa';

  @override
  String get source => 'Origen';

  @override
  String get sourceHint => 'Ej: Instagram, referido, web';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get undo => 'Deshacer';

  @override
  String get retry => 'Reintentar';

  @override
  String get newClient => 'Nuevo cliente';

  @override
  String get createClient => 'Crear cliente';

  @override
  String get nameRequired => 'El nombre es requerido';

  @override
  String get required => 'Requerido';

  @override
  String get clientUpdated => '✅ Cliente actualizado';

  @override
  String get clientDeleted => 'Cliente eliminado';

  @override
  String get deleteClient => 'Eliminar cliente';

  @override
  String deleteClientConfirm(String name) {
    return '¿Estás seguro de que querés eliminar a \"$name\"? Esta acción se puede deshacer.';
  }

  @override
  String moveClientTo(String name) {
    return 'Mover \"$name\" a:';
  }

  @override
  String get noClients => 'Sin clientes';

  @override
  String get noPhoneNumber => 'Este cliente no tiene teléfono';

  @override
  String get newNote => 'Nueva nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteHint => 'Escribí tu nota...';

  @override
  String get saveNote => 'Guardar nota';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String get noNotes => 'Sin notas aún';

  @override
  String get noNotesHint => 'Agregá una con el botón +';

  @override
  String get noteDeleted => 'Nota eliminada';

  @override
  String get newTask => 'Nueva tarea';

  @override
  String get editTask => 'Editar tarea';

  @override
  String get taskTitle => 'Título de la tarea';

  @override
  String get taskDueDate => 'Fecha de vencimiento (opcional)';

  @override
  String get createTask => 'Crear tarea';

  @override
  String get noTasks => 'Sin tareas pendientes';

  @override
  String get noTasksHint => 'Creá una con el botón +';

  @override
  String get taskDeleted => 'Tarea eliminada';

  @override
  String dueDate(String date) {
    return 'Vence: $date';
  }

  @override
  String get complete => 'Completar';

  @override
  String get allCaughtUp => '¡Todo al día!';

  @override
  String get noPendingTasks => 'No hay tareas pendientes';

  @override
  String get info => 'Info';

  @override
  String get notes => 'Notas';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get somethingWentWrong => 'Algo salió mal';

  @override
  String get searchClients => 'Buscar clientes...';

  @override
  String get typeToSearch => 'Escribí para buscar';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get sortRecent => 'Más recientes';

  @override
  String get sortName => 'Nombre A-Z';

  @override
  String get sortOldest => 'Más antiguos';

  @override
  String get sort => 'Ordenar';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAuto => 'Automático';

  @override
  String get noEmail => 'Sin email';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirm => '¿Estás seguro?';

  @override
  String get language => 'Idioma';

  @override
  String get created => 'Creado';

  @override
  String get updated => 'Actualizado';

  @override
  String get statusNew => 'Nuevo';

  @override
  String get statusContacted => 'Contactado';

  @override
  String get statusInterested => 'Interesado';

  @override
  String get statusNegotiating => 'Negociando';

  @override
  String get statusClosedWon => 'Ganado';

  @override
  String get statusClosedLost => 'Perdido';

  @override
  String get newLabel => 'Nuevo';

  @override
  String get filters => 'Filtros';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get filterByDate => 'Filtrar por fecha';

  @override
  String get filterBySource => 'Filtrar por origen';

  @override
  String get dateRange => 'Rango de fechas';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get allSources => 'Todos';

  @override
  String get apply => 'Aplicar';

  @override
  String activeFilters(int count) {
    return '$count filtro(s) activo(s)';
  }

  @override
  String get metrics => 'Métricas';

  @override
  String get conversionRate => 'Tasa de conversión';

  @override
  String get newThisWeek => 'Nuevos esta semana';

  @override
  String get newThisMonth => 'Nuevos este mes';

  @override
  String get overdueTasks => 'Tareas vencidas';

  @override
  String get totalClients => 'Total clientes';

  @override
  String get byStatus => 'Por estado';

  @override
  String get followUpReminder => 'Recordatorio de seguimiento';

  @override
  String get setFollowUp => 'Programar seguimiento';

  @override
  String get followUpDate => 'Fecha de seguimiento';

  @override
  String get followUpDue => 'Seguimiento vencido';

  @override
  String get followUpScheduled => 'Seguimiento programado';

  @override
  String get removeFollowUp => 'Quitar recordatorio';

  @override
  String get followUpUpdated => 'Seguimiento actualizado';

  @override
  String get dealValue => 'Monto de venta';

  @override
  String get currency => 'Moneda';

  @override
  String get totalRevenue => 'Revenue total';

  @override
  String get revenueThisMonth => 'Revenue este mes';

  @override
  String get revenueWon => 'Revenue ganado';

  @override
  String get revenueByStatus => 'Revenue por estado';

  @override
  String get metricsTitle => 'Métricas 📊';

  @override
  String get exportCsv => 'Exportar datos (CSV)';

  @override
  String get settings => 'Configuración';
}

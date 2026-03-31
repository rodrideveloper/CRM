// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'CRM WhatsApp';

  @override
  String get pipeline => 'Pipeline';

  @override
  String get tasks => 'Tasks';

  @override
  String get profile => 'Profile';

  @override
  String get pipelineTitle => 'Pipeline 🎯';

  @override
  String get tasksTitle => 'Tasks 📋';

  @override
  String get profileTitle => 'Profile 👤';

  @override
  String get loginWelcome => 'Welcome back! 👋';

  @override
  String get loginSubtitle => 'Sign in and close more deals';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Sign up';

  @override
  String get registerWelcome => 'Get started! 🚀';

  @override
  String get registerSubtitle => 'Create your account and organize your sales';

  @override
  String get registerButton => 'Create account';

  @override
  String get registerHasAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Sign in';

  @override
  String get registerSuccess => 'Account created! Check your email to confirm.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Invalid email';

  @override
  String get password => 'Password';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get phoneHint => '+5491112345678';

  @override
  String get phoneWithCountry => 'Phone (with country code)';

  @override
  String get company => 'Company';

  @override
  String get source => 'Source';

  @override
  String get sourceHint => 'E.g.: Instagram, referral, web';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get undo => 'Undo';

  @override
  String get retry => 'Retry';

  @override
  String get newClient => 'New client';

  @override
  String get createClient => 'Create client';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get required => 'Required';

  @override
  String get clientUpdated => '✅ Client updated';

  @override
  String get clientDeleted => 'Client deleted';

  @override
  String get deleteClient => 'Delete client';

  @override
  String deleteClientConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"? This action can be undone.';
  }

  @override
  String moveClientTo(String name) {
    return 'Move \"$name\" to:';
  }

  @override
  String get noClients => 'No clients';

  @override
  String get noPhoneNumber => 'This client has no phone number';

  @override
  String get newNote => 'New note';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteHint => 'Write your note...';

  @override
  String get saveNote => 'Save note';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get noNotes => 'No notes yet';

  @override
  String get noNotesHint => 'Add one with the + button';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get newTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskTitle => 'Task title';

  @override
  String get taskDueDate => 'Due date (optional)';

  @override
  String get createTask => 'Create task';

  @override
  String get noTasks => 'No pending tasks';

  @override
  String get noTasksHint => 'Create one with the + button';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String dueDate(String date) {
    return 'Due: $date';
  }

  @override
  String get complete => 'Complete';

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get noPendingTasks => 'No pending tasks';

  @override
  String get info => 'Info';

  @override
  String get notes => 'Notes';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get searchClients => 'Search clients...';

  @override
  String get typeToSearch => 'Type to search';

  @override
  String get noResults => 'No results';

  @override
  String get sortRecent => 'Most recent';

  @override
  String get sortName => 'Name A-Z';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sort => 'Sort';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeAuto => 'Auto';

  @override
  String get noEmail => 'No email';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirm => 'Are you sure?';

  @override
  String get language => 'Language';

  @override
  String get created => 'Created';

  @override
  String get updated => 'Updated';

  @override
  String get statusNew => 'New';

  @override
  String get statusContacted => 'Contacted';

  @override
  String get statusInterested => 'Interested';

  @override
  String get statusNegotiating => 'Negotiating';

  @override
  String get statusClosedWon => 'Won';

  @override
  String get statusClosedLost => 'Lost';

  @override
  String get newLabel => 'New';

  @override
  String get filters => 'Filters';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get filterBySource => 'Filter by source';

  @override
  String get dateRange => 'Date range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get allSources => 'All';

  @override
  String get apply => 'Apply';

  @override
  String activeFilters(int count) {
    return '$count active filter(s)';
  }

  @override
  String get metrics => 'Metrics';

  @override
  String get conversionRate => 'Conversion rate';

  @override
  String get newThisWeek => 'New this week';

  @override
  String get newThisMonth => 'New this month';

  @override
  String get overdueTasks => 'Overdue tasks';

  @override
  String get totalClients => 'Total clients';

  @override
  String get byStatus => 'By status';

  @override
  String get followUpReminder => 'Follow-up reminder';

  @override
  String get setFollowUp => 'Set follow-up';

  @override
  String get followUpDate => 'Follow-up date';

  @override
  String get followUpDue => 'Follow-up overdue';

  @override
  String get followUpScheduled => 'Follow-up scheduled';

  @override
  String get removeFollowUp => 'Remove reminder';

  @override
  String get followUpUpdated => 'Follow-up updated';
}

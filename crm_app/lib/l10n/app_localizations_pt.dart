// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'CRM WhatsApp';

  @override
  String get pipeline => 'Pipeline';

  @override
  String get tasks => 'Tarefas';

  @override
  String get profile => 'Perfil';

  @override
  String get pipelineTitle => 'Pipeline 🎯';

  @override
  String get tasksTitle => 'Tarefas 📋';

  @override
  String get profileTitle => 'Perfil 👤';

  @override
  String get loginWelcome => 'Bem-vindo de volta! 👋';

  @override
  String get loginSubtitle => 'Entre e feche mais vendas';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginNoAccount => 'Não tem conta? ';

  @override
  String get loginRegisterLink => 'Cadastre-se';

  @override
  String get registerWelcome => 'Comece agora! 🚀';

  @override
  String get registerSubtitle => 'Crie sua conta e organize suas vendas';

  @override
  String get registerButton => 'Criar conta';

  @override
  String get registerHasAccount => 'Já tem conta? ';

  @override
  String get registerLoginLink => 'Entrar';

  @override
  String get registerSuccess =>
      'Conta criada! Verifique seu email para confirmar.';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Email inválido';

  @override
  String get password => 'Senha';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get name => 'Nome';

  @override
  String get phone => 'Telefone';

  @override
  String get phoneHint => '+5491112345678';

  @override
  String get phoneWithCountry => 'Telefone (com código do país)';

  @override
  String get company => 'Empresa';

  @override
  String get source => 'Origem';

  @override
  String get sourceHint => 'Ex: Instagram, indicação, web';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get undo => 'Desfazer';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get newClient => 'Novo cliente';

  @override
  String get createClient => 'Criar cliente';

  @override
  String get nameRequired => 'O nome é obrigatório';

  @override
  String get required => 'Obrigatório';

  @override
  String get clientUpdated => '✅ Cliente atualizado';

  @override
  String get clientDeleted => 'Cliente excluído';

  @override
  String get deleteClient => 'Excluir cliente';

  @override
  String deleteClientConfirm(String name) {
    return 'Tem certeza de que deseja excluir \"$name\"? Esta ação pode ser desfeita.';
  }

  @override
  String moveClientTo(String name) {
    return 'Mover \"$name\" para:';
  }

  @override
  String get noClients => 'Sem clientes';

  @override
  String get noPhoneNumber => 'Este cliente não tem telefone';

  @override
  String get newNote => 'Nova nota';

  @override
  String get editNote => 'Editar nota';

  @override
  String get noteHint => 'Escreva sua nota...';

  @override
  String get saveNote => 'Salvar nota';

  @override
  String get saveChanges => 'Salvar alterações';

  @override
  String get noNotes => 'Sem notas ainda';

  @override
  String get noNotesHint => 'Adicione uma com o botão +';

  @override
  String get noteDeleted => 'Nota excluída';

  @override
  String get newTask => 'Nova tarefa';

  @override
  String get editTask => 'Editar tarefa';

  @override
  String get taskTitle => 'Título da tarefa';

  @override
  String get taskDueDate => 'Data de vencimento (opcional)';

  @override
  String get createTask => 'Criar tarefa';

  @override
  String get noTasks => 'Sem tarefas pendentes';

  @override
  String get noTasksHint => 'Crie uma com o botão +';

  @override
  String get taskDeleted => 'Tarefa excluída';

  @override
  String dueDate(String date) {
    return 'Vence: $date';
  }

  @override
  String get complete => 'Completar';

  @override
  String get allCaughtUp => 'Tudo em dia!';

  @override
  String get noPendingTasks => 'Sem tarefas pendentes';

  @override
  String get info => 'Info';

  @override
  String get notes => 'Notas';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get somethingWentWrong => 'Algo deu errado';

  @override
  String get searchClients => 'Buscar clientes...';

  @override
  String get typeToSearch => 'Digite para buscar';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get sortRecent => 'Mais recentes';

  @override
  String get sortName => 'Nome A-Z';

  @override
  String get sortOldest => 'Mais antigos';

  @override
  String get sort => 'Ordenar';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeAuto => 'Automático';

  @override
  String get noEmail => 'Sem email';

  @override
  String get logout => 'Sair';

  @override
  String get logoutConfirm => 'Tem certeza?';

  @override
  String get language => 'Idioma';

  @override
  String get created => 'Criado';

  @override
  String get updated => 'Atualizado';

  @override
  String get statusNew => 'Novo';

  @override
  String get statusContacted => 'Contatado';

  @override
  String get statusInterested => 'Interessado';

  @override
  String get statusNegotiating => 'Negociando';

  @override
  String get statusClosedWon => 'Ganho';

  @override
  String get statusClosedLost => 'Perdido';

  @override
  String get newLabel => 'Novo';

  @override
  String get filters => 'Filtros';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get filterByDate => 'Filtrar por data';

  @override
  String get filterBySource => 'Filtrar por origem';

  @override
  String get dateRange => 'Período';

  @override
  String get from => 'De';

  @override
  String get to => 'Até';

  @override
  String get allSources => 'Todos';

  @override
  String get apply => 'Aplicar';

  @override
  String activeFilters(int count) {
    return '$count filtro(s) ativo(s)';
  }

  @override
  String get metrics => 'Métricas';

  @override
  String get conversionRate => 'Taxa de conversão';

  @override
  String get newThisWeek => 'Novos esta semana';

  @override
  String get newThisMonth => 'Novos este mês';

  @override
  String get overdueTasks => 'Tarefas atrasadas';

  @override
  String get totalClients => 'Total de clientes';

  @override
  String get byStatus => 'Por status';

  @override
  String get followUpReminder => 'Lembrete de acompanhamento';

  @override
  String get setFollowUp => 'Agendar acompanhamento';

  @override
  String get followUpDate => 'Data de acompanhamento';

  @override
  String get followUpDue => 'Acompanhamento atrasado';

  @override
  String get followUpScheduled => 'Acompanhamento agendado';

  @override
  String get removeFollowUp => 'Remover lembrete';

  @override
  String get followUpUpdated => 'Acompanhamento atualizado';

  @override
  String get dealValue => 'Valor da venda';

  @override
  String get currency => 'Moeda';

  @override
  String get totalRevenue => 'Receita total';

  @override
  String get revenueThisMonth => 'Receita este mês';

  @override
  String get revenueWon => 'Receita ganha';

  @override
  String get revenueByStatus => 'Receita por status';

  @override
  String get metricsTitle => 'Métricas 📊';

  @override
  String get exportCsv => 'Exportar dados (CSV)';

  @override
  String get settings => 'Configurações';

  @override
  String get myLeadForm => 'Meu formulário de captação';

  @override
  String get copyLink => 'Copiar link';

  @override
  String get share => 'Compartilhar';

  @override
  String get linkCopied => 'Link copiado';

  @override
  String get shareFormText => 'Deixe seus dados aqui!';

  @override
  String get formActive => 'Formulário ativo';

  @override
  String get formInactive => 'Formulário desabilitado';

  @override
  String get upgradeToPro => 'Passe para Pro 🚀';

  @override
  String clientLimitReached(int count, int limit) {
    return 'Você usou $count de $limit clientes no plano Free';
  }

  @override
  String upToNClients(int n) {
    return 'Até $n clientes';
  }

  @override
  String get unlimitedClients => 'Clientes ilimitados';

  @override
  String get basicPipeline => 'Pipeline de vendas';

  @override
  String get notesAndTasks => 'Notas e tarefas';

  @override
  String get subscribePro => 'Assinar Pro';

  @override
  String get cancelAnytime => 'Cancele quando quiser. Sem compromisso.';

  @override
  String get myPlan => 'Meu plano';

  @override
  String get freePlan => 'Plano Free';

  @override
  String get proPlan => 'Plano Pro';

  @override
  String clientsUsed(int count, int limit) {
    return '$count/$limit clientes';
  }

  @override
  String clientsUnlimited(int count) {
    return '$count clientes (ilimitado)';
  }

  @override
  String get upgrade => 'Melhorar plano';
}

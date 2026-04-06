import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/supabase_constants.dart';
import 'core/theme/web_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const CrmWebApp());
}

class CrmWebApp extends StatelessWidget {
  const CrmWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TRATAR - CRM de seguimiento comercial',
      debugShowCheckedModeBanner: false,
      theme: WebTheme.dark,
      initialRoute: AppRouter.landing,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

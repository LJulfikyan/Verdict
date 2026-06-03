import 'package:flutter/widgets.dart';

import 'core/routes/app_router.dart';
import 'core/services/app_initializer.dart';
import 'core/widgets/verdict_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initializer = AppInitializer();
  await initializer.initialize();

  runApp(VerdictApp(router: AppRouter().router));
}

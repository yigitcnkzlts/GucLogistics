import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/guc_app.dart';
import 'core/storage/prefs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>('loads_cache');
  await Hive.openBox<String>('offline_cache');
  final prefs = await PrefsService.create();
  runApp(
    ProviderScope(
      overrides: [prefsServiceProvider.overrideWithValue(prefs)],
      child: const GucApp(),
    ),
  );
}

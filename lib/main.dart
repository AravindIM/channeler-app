import 'package:channeler/backend/backend.dart';
import 'package:channeler/router.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));
  runApp(
    Provider<Backend>(
      create: (_) => Backend(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Channeler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: Colors.white, onBackground: Colors.black),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                foregroundColor: MaterialStateProperty.all(Colors.white))),
      ),
      routerConfig: appRouter,
    );
  }
}

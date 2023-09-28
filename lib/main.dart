import 'package:channeler/backend/api_endpoint.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/router.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 1));
  runApp(
    Provider<Session>(
      create: (_) => Session(api: ApiEndpoint.for4chan()),
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
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
        listTileTheme: ListTileThemeData(
          selectedTileColor: Colors.green.shade100,
          selectedColor: Colors.black,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}

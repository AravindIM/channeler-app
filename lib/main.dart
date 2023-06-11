import 'package:channeler/backend/backend.dart';
import 'package:channeler/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider<Backend>(
    create: (_) => Backend(),
    child: const MyApp(),
  ));
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
      ),
      routerConfig: appRouter,
    );
  }
}

import 'package:channeler/routes/board_page.dart';
import 'package:channeler/routes/home_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(title: 'Channeler'),
    ),
    GoRoute(
      path: '/board/:name',
      builder: (context, state) =>
          BoardPage(name: state.pathParameters['name']!),
    ),
  ],
);

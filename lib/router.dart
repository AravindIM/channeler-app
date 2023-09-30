import 'package:channeler/routes/catalog_page.dart';
import 'package:channeler/routes/home_page.dart';
import 'package:channeler/routes/thread_page.dart';
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
          CatalogPage(name: state.pathParameters['name']!),
    ),
    GoRoute(
      path: '/thread/:board/:id',
      builder: (context, state) => ThreadPage(
        boardName: state.pathParameters['board']!,
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
);

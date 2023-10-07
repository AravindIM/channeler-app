import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/boardmenu/boardmenu.dart';
import 'package:channeler/widgets/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//convert to stateless widget
class CatalogPage extends StatelessWidget {
  final String name;

  const CatalogPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final board = session.findBoardByName(name);
    final title = board.title;
    final pageKey = PageStorageKey<String>("/${board.name}/");
    final CatalogPaginator paginator = CatalogPaginator(boardName: name);

    return Scaffold(
        drawer: BoardMenu(
          session: Provider.of<Session>(context),
          currentBoard: name,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              title: Text(title),
            ),
          ],
          body: PageStorage(
            bucket: session.pageBucket,
            child: Feed(
              key: pageKey,
              session: session,
              paginator: paginator,
              board: board,
            ),
          ),
        ));
  }
}

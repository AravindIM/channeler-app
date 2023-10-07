import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/boardmenu/boardmenu.dart';
import 'package:channeler/widgets/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//convert to stateless widget
class ThreadPage extends StatelessWidget {
  final String boardName;
  final int id;

  const ThreadPage({super.key, required this.boardName, required this.id});

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final board = session.findBoardByName(boardName);
    final title = '>>$id';
    ThreadPaginator paginator = ThreadPaginator(boardName: boardName, id: id);
    final pageKey = PageStorageKey<String>("/${board.name}/$id");

    return Scaffold(
        drawer: BoardMenu(
          session: Provider.of<Session>(context),
          currentBoard: boardName,
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

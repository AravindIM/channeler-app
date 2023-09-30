import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/feed/feed.dart';
import 'package:channeler/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//convert to stateless widget
class ThreadPage extends StatefulWidget {
  final String boardName;
  final int id;

  const ThreadPage({super.key, required this.boardName, required this.id});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  ThreadPaginator? paginator;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final board = session.findBoardByName(widget.boardName);
    final title = '>>${widget.id}';
    paginator = ThreadPaginator(boardName: widget.boardName, id: widget.id);
    return Scaffold(
        drawer: SideMenu(
          session: Provider.of<Session>(context),
          currentBoard: widget.boardName,
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
          body: Feed(
            session: session,
            paginator: paginator as ThreadPaginator,
            board: board,
          ),
        ));
  }
}

import 'package:channeler/backend/paginator.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/feed/feed.dart';
import 'package:channeler/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//convert to stateless widget
class CatalogPage extends StatefulWidget {
  final String name;

  const CatalogPage({super.key, required this.name});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  CatalogPaginator? paginator;

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<Session>(context);
    final board = session.findBoardByName(widget.name);
    final title = board.title;
    paginator = CatalogPaginator(boardName: widget.name);
    return Scaffold(
        drawer: SideMenu(currentBoard: widget.name),
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
              paginator: paginator as CatalogPaginator,
              board: board),
        ));
  }
}

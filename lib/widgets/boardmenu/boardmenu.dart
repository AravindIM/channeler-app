import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/boardmenu/board_list_view.dart';
import 'package:flutter/material.dart';

class BoardMenu extends StatelessWidget {
  final String currentBoard;
  final Session session;

  const BoardMenu(
      {super.key, required this.session, required this.currentBoard});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      surfaceTintColor: colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.background),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Channeler',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    'Boards',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PageStorage(
            bucket: session.appBucket,
            child: BoardListView(
              session: session,
              currentBoard: currentBoard,
            ),
          ),
        ],
      ),
    );
  }
}

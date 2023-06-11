import 'dart:math';
import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key, required this.currentBoard});
  final String currentBoard;

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
              child: Text(
                'Boards',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          BoardListView(
            currentBoard: currentBoard,
          )
        ],
      ),
    );
  }
}

class BoardListView extends StatefulWidget {
  const BoardListView({super.key, required this.currentBoard});
  final String currentBoard;

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  @override
  Widget build(BuildContext context) {
    final backend = Provider.of<Backend>(context);
    return FutureBuilder<List<Board>>(
        future: backend.fetchBoards(),
        builder: (context, snapshot) {
          Widget child;
          if (snapshot.hasData) {
            child = ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final colorScheme = Theme.of(context).colorScheme;
                final MaterialColor primaryColor =
                    colorScheme.primary as MaterialColor;
                final shade = 500 + Random().nextInt(4) * 100;
                final board = snapshot.data![index];
                final boardName = board.name;
                final boardTitle = board.title;
                final bool isSelected = boardName == widget.currentBoard;
                return ListTile(
                  selected: isSelected,
                  selectedColor: colorScheme.onBackground,
                  selectedTileColor: primaryColor.shade100,
                  leading: CircleAvatar(
                    backgroundColor: primaryColor[shade],
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '/$boardName/',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  title: Text(boardTitle),
                  onTap: () {
                    context.go('/board/$boardName');
                    context.pop();
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            child = ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.error_outline),
                  title: Text(
                    'Sorry, we could not fetch boards! Try checking if you are connected to the internet',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          } else {
            child = ListView(
              children: const [
                ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text(
                    'Loading list of Boards! Please wait!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }
          return Expanded(child: child);
        });
  }
}

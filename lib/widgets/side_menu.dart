import 'dart:math';
import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Boards',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 26,
                ),
              ),
            ),
          ),
          const BoardListView()
        ],
      ),
    );
  }
}

class BoardListView extends StatefulWidget {
  const BoardListView({super.key});

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
                final board = snapshot.data![index];
                final boardName = board.name;
                final boardTitle = board.title;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('/$boardName/'),
                      ),
                    ),
                  ),
                  title: Text(boardTitle),
                  onTap: () {
                    Navigator.pop(context);
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

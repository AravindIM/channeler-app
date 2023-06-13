import 'package:channeler/widgets/board_list_view.dart';
import 'package:flutter/material.dart';

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
                  color: colorScheme.primary,
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

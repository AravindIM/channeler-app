import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/boardmenu/boardmenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      drawer: BoardMenu(
        session: Provider.of<Session>(context),
        currentBoard: '',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            foregroundColor: colorScheme.primary,
            title: Text(widget.title),
          )
        ],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hello Anon!',
                  style: TextStyle(
                    fontSize: 100,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  '> Welcome to ${widget.title}!',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '> Check the sidebar for the list of boards.',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

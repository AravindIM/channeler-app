import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/thread.dart';
import 'package:channeler/widgets/feed/feed_card_text_body.dart';
import 'package:channeler/widgets/feed/feed_card_footer.dart';
import 'package:channeler/widgets/feed/feed_card_header.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({super.key, required this.thread, required this.board});
  final Thread thread;
  final Board board;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Thread thread = widget.thread;
    final board = widget.board;

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      surfaceTintColor: colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedCardHeader(
            board: board,
            post: thread.post,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          ),
          const Divider(
            thickness: 0.2,
            color: Colors.grey,
          ),
          FeedCardTextBody(
              post: thread.post,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5)),
          FeedCardFooter(
              post: thread.post,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5))
        ],
      ),
    );
  }
}

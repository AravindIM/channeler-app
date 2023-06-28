import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/thread.dart';
import 'package:channeler/widgets/feed/feed_card_text_body.dart';
import 'package:channeler/widgets/feed/feed_card_footer.dart';
import 'package:channeler/widgets/feed/feed_card_header.dart';
import 'package:channeler/widgets/media/media_handler.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  const FeedCard(
      {super.key,
      required this.thread,
      required this.board,
      required this.backend});
  final Thread thread;
  final Board board;
  final Backend backend;

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
    final post = thread.post;
    final backend = widget.backend;
    final String attachment = post.attachment ?? '';

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      surfaceTintColor: colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeedCardHeader(
            board: board,
            post: post,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          ),
          const Divider(
            thickness: 0.2,
            color: Colors.grey,
            height: 0.2,
          ),
          if (attachment.isNotEmpty)
            MediaHandler(
                mediaUrl: backend.api
                    .getAttachment(board.name, attachment)
                    .toString()),
          if (attachment.isNotEmpty)
            const Divider(
              thickness: 0.2,
              color: Colors.grey,
              height: 0.2,
            ),
          if (attachment.isNotEmpty) const SizedBox(height: 20),
          FeedCardTextBody(
              post: post, padding: const EdgeInsets.fromLTRB(20, 5, 20, 5)),
          FeedCardFooter(
              post: post, padding: const EdgeInsets.fromLTRB(20, 5, 20, 5))
        ],
      ),
    );
  }
}

import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:channeler/backend/session.dart';
import 'package:channeler/widgets/feed/feed_card_text_body.dart';
import 'package:channeler/widgets/feed/feed_card_footer.dart';
import 'package:channeler/widgets/feed/feed_card_header.dart';
import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:channeler/widgets/media/media_handler.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({
    super.key,
    required this.post,
    required this.board,
    required this.session,
    required this.flickMultiManager,
  });
  final Post post;
  final Board board;
  final Session session;
  final FlickMultiManager flickMultiManager;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Post post = widget.post;
    final board = widget.board;
    final session = widget.session;
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
              mediaUrl:
                  session.api.getAttachment(board.name, attachment).toString(),
              flickMultiManager: widget.flickMultiManager,
            ),
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

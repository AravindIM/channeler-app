import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCardHeader extends StatelessWidget {
  const FeedCardHeader(
      {super.key,
      required this.board,
      required this.post,
      required this.padding});
  final Board board;
  final Post post;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final nsfwColor = colorScheme.error;
    final onNsfwColor = colorScheme.onError;
    final String timestamp = timeago.format(post.timestamp, locale: 'en_short');
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: board.nsfw ? nsfwColor : colorScheme.primary,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    '/${board.name}/',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color:
                            board.nsfw ? onNsfwColor : colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                Text(
                  timestamp,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ],
            ),
          ),
          post.pinned
              ? const Icon(Icons.push_pin, size: 20.0)
              : const SizedBox(
                  width: 20.0,
                ),
        ],
      ),
    );
  }
}

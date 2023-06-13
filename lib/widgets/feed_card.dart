import 'package:channeler/backend/thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedCard extends StatefulWidget {
  const FeedCard({super.key, required this.thread});
  final Thread thread;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    const double iconSize = 20;
    final colorScheme = Theme.of(context).colorScheme;
    final Thread thread = widget.thread;
    final String title =
        thread.post.title.isEmpty ? 'Untitled' : thread.post.title;
    final String content = thread.post.content;
    final String username = thread.post.username;
    final int replyCount = thread.post.replyCount;
    final String timestamp = timeago.format(thread.post.timestamp);
    final bool pinned = thread.post.pinned;

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      surfaceTintColor: colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 280,
                  child: Expanded(
                    child: Text(
                      title,
                      softWrap: true,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                if (pinned) const Icon(Icons.push_pin, size: iconSize),
              ],
            ),
            Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
                const Spacer(flex: 1),
                Text(
                  timestamp,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Markdown(
              padding: EdgeInsets.zero,
              data: content,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                blockquotePadding: const EdgeInsets.all(20),
                blockquoteDecoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: isLiked
                      ? const Icon(
                          Icons.favorite_outlined,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_outline),
                  iconSize: iconSize,
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  iconSize: iconSize,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Row(
                    children: [
                      const Icon(Icons.comment_outlined),
                      const SizedBox(width: 5),
                      Text(replyCount.toString())
                    ],
                  ),
                  iconSize: iconSize,
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

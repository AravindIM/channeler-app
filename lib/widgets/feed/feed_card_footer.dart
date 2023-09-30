import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedCardFooter extends StatefulWidget {
  const FeedCardFooter(
      {super.key,
      required this.board,
      required this.post,
      required this.padding});
  final Post post;
  final Board board;
  final EdgeInsets padding;

  @override
  State<FeedCardFooter> createState() => _FeedCardFooterState();
}

class _FeedCardFooterState extends State<FeedCardFooter> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;
    return Padding(
      padding: widget.padding,
      child: Row(
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
                Text(widget.post.replyCount.toString())
              ],
            ),
            iconSize: iconSize,
            onPressed: () {
              context.push('/thread/${widget.board.name}/${widget.post.id}');
            },
          ),
        ],
      ),
    );
  }
}

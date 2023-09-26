import 'package:channeler/backend/backend.dart';
import 'package:channeler/backend/board.dart';
import 'package:channeler/backend/post.dart';
import 'package:channeler/widgets/feed/feed_card.dart';
import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Feed extends StatefulWidget {
  const Feed({super.key, required this.backend, required this.board});
  final Backend backend;
  final Board board;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);
  late FlickMultiManager flickMultiManager;

  @override
  void initState() {
    flickMultiManager = FlickMultiManager();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(widget.backend, widget.board.name, pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(
      Backend backend, String boardName, int pageKey) async {
    try {
      final Board board = backend.findBoardByName(boardName);
      final List<Post> newItems = await backend.fetchPage(boardName, pageKey);
      final isLastPage =
          newItems.length < board.threadsPerPage || pageKey == board.pages;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void didUpdateWidget(Feed oldWidget) {
    _pagingController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickMultiManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && mounted) {
          flickMultiManager.pause();
        }
      },
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, Post>(
          padding: EdgeInsets.zero,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, Post item, index) {
              return FeedCard(
                backend: widget.backend,
                post: item,
                board: widget.board,
                flickMultiManager: flickMultiManager,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
